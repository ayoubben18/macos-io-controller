import Foundation
import AVFoundation
import Combine

/// Manages video device enumeration and control using AVFoundation
final class VideoDeviceManager: ObservableObject {
    @Published private(set) var cameras: [VideoDevice] = []
    @Published private(set) var selectedCameraID: String?

    private var discoverySession: AVCaptureDevice.DiscoverySession?
    private var observer: NSObjectProtocol?

    init() {
        setupDiscoverySession()
        refreshDevices()
        setupDeviceChangeObserver()
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    // MARK: - Public API

    /// Refresh the list of video devices
    func refreshDevices() {
        guard let session = discoverySession else {
            cameras = []
            return
        }

        let defaultDevice = AVCaptureDevice.default(for: .video)

        cameras = session.devices.map { device in
            VideoDevice(
                id: device.uniqueID,
                name: device.localizedName,
                isEnabled: true,
                isDefault: device.uniqueID == defaultDevice?.uniqueID,
                isInUse: device.isInUseByAnotherApplication
            )
        }

        // Set selected camera to default if not already set
        if selectedCameraID == nil {
            selectedCameraID = defaultDevice?.uniqueID
        }
    }

    /// Select a camera as the preferred device
    /// Note: macOS doesn't have a system-wide default camera setting.
    /// This tracks the user's preference for apps to query.
    func selectCamera(_ camera: VideoDevice) {
        selectedCameraID = camera.id

        // Update isDefault flag in cameras array
        cameras = cameras.map { cam in
            var updatedCam = cam
            updatedCam.isDefault = cam.id == camera.id
            return updatedCam
        }
    }

    /// Get the currently selected camera
    var selectedCamera: VideoDevice? {
        cameras.first { $0.id == selectedCameraID }
    }

    /// Get AVCaptureDevice for a VideoDevice
    func captureDevice(for device: VideoDevice) -> AVCaptureDevice? {
        AVCaptureDevice(uniqueID: device.id)
    }

    // MARK: - Private Methods

    private func setupDiscoverySession() {
        // Discover all video capture devices including external cameras
        discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [
                .builtInWideAngleCamera,
                .external
            ],
            mediaType: .video,
            position: .unspecified
        )
    }

    private func setupDeviceChangeObserver() {
        // Observe device connection/disconnection
        observer = NotificationCenter.default.addObserver(
            forName: .AVCaptureDeviceWasConnected,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refreshDevices()
        }

        NotificationCenter.default.addObserver(
            forName: .AVCaptureDeviceWasDisconnected,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refreshDevices()
        }
    }
}
