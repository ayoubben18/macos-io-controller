import SwiftUI

struct AudioSectionView: View {
    @ObservedObject var audioManager: AudioDeviceManager
    let isInput: Bool

    private var devices: [AudioDevice] {
        isInput ? audioManager.inputDevices : audioManager.outputDevices
    }

    private var currentDevice: AudioDevice? {
        devices.first { $0.isDefault }
    }

    var body: some View {
        VStack(spacing: 0) {
            if devices.isEmpty {
                Text("No \(isInput ? "input" : "output") devices available")
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding()
            } else {
                // Device list
                ForEach(devices) { device in
                    DeviceRowView(device: device) {
                        if isInput {
                            audioManager.setDefaultInputDevice(device)
                        } else {
                            audioManager.setDefaultOutputDevice(device)
                        }
                    }
                }

                Divider()
                    .padding(.vertical, 4)

                // Volume control for current device
                if let device = currentDevice {
                    VolumeControlView(
                        volume: Binding(
                            get: { device.volume },
                            set: { _ in }
                        ),
                        isMuted: Binding(
                            get: { device.isMuted },
                            set: { _ in }
                        ),
                        isInput: isInput,
                        onVolumeChange: { newVolume in
                            audioManager.setVolume(newVolume, for: device)
                        },
                        onMuteToggle: {
                            audioManager.toggleMute(for: device)
                        }
                    )
                }
            }
        }
    }
}
