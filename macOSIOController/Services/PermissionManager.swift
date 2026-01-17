import Foundation
import AVFoundation
import AppKit
import Combine

/// Manages microphone and camera permission requests and status
final class PermissionManager: ObservableObject {
    @Published private(set) var microphoneStatus: AVAuthorizationStatus = .notDetermined
    @Published private(set) var cameraStatus: AVAuthorizationStatus = .notDetermined

    init() {
        refreshStatus()
    }

    // MARK: - Public API

    /// Refresh the current authorization status for both permissions
    func refreshStatus() {
        microphoneStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }

    /// Request microphone permission
    func requestMicrophonePermission() {
        AVCaptureDevice.requestAccess(for: .audio) { [weak self] _ in
            DispatchQueue.main.async {
                self?.refreshStatus()
            }
        }
    }

    /// Request camera permission
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] _ in
            DispatchQueue.main.async {
                self?.refreshStatus()
            }
        }
    }

    /// Open System Settings to the Privacy & Security section
    static func openSystemSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy") {
            NSWorkspace.shared.open(url)
        }
    }

    /// Check if microphone access is authorized
    var isMicrophoneAuthorized: Bool {
        microphoneStatus == .authorized
    }

    /// Check if camera access is authorized
    var isCameraAuthorized: Bool {
        cameraStatus == .authorized
    }

    /// Check if microphone permission was denied
    var isMicrophoneDenied: Bool {
        microphoneStatus == .denied || microphoneStatus == .restricted
    }

    /// Check if camera permission was denied
    var isCameraDenied: Bool {
        cameraStatus == .denied || cameraStatus == .restricted
    }
}
