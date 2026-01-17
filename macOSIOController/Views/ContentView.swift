import SwiftUI

struct ContentView: View {
    @StateObject private var audioManager = AudioDeviceManager()
    @StateObject private var videoManager = VideoDeviceManager()
    @StateObject private var permissionManager = PermissionManager()
    @State private var expandedSection: AccordionSection? = .audioOutput

    var body: some View {
        VStack(spacing: 0) {
            AccordionView(
                title: "Audio Output",
                systemImage: "speaker.wave.2.fill",
                section: .audioOutput,
                expandedSection: $expandedSection
            ) {
                AudioSectionView(audioManager: audioManager, isInput: false)
            }

            Divider()

            AccordionView(
                title: "Audio Input",
                systemImage: "mic.fill",
                section: .audioInput,
                expandedSection: $expandedSection,
                onExpand: {
                    requestMicrophonePermissionIfNeeded()
                }
            ) {
                AudioInputSectionContent(
                    audioManager: audioManager,
                    permissionManager: permissionManager
                )
            }

            Divider()

            AccordionView(
                title: "Camera",
                systemImage: "camera.fill",
                section: .camera,
                expandedSection: $expandedSection,
                onExpand: {
                    requestCameraPermissionIfNeeded()
                }
            ) {
                CameraSectionContent(
                    videoManager: videoManager,
                    permissionManager: permissionManager
                )
            }
        }
        .frame(width: 280)
    }

    private func requestMicrophonePermissionIfNeeded() {
        if permissionManager.microphoneStatus == .notDetermined {
            permissionManager.requestMicrophonePermission()
        }
    }

    private func requestCameraPermissionIfNeeded() {
        if permissionManager.cameraStatus == .notDetermined {
            permissionManager.requestCameraPermission()
        }
    }
}

/// Audio Input section with permission handling
struct AudioInputSectionContent: View {
    @ObservedObject var audioManager: AudioDeviceManager
    @ObservedObject var permissionManager: PermissionManager

    var body: some View {
        if permissionManager.isMicrophoneDenied {
            PermissionDeniedView(
                permissionType: .microphone,
                onOpenSettings: PermissionManager.openSystemSettings
            )
        } else {
            AudioSectionView(audioManager: audioManager, isInput: true)
        }
    }
}

/// Camera section with permission handling
struct CameraSectionContent: View {
    @ObservedObject var videoManager: VideoDeviceManager
    @ObservedObject var permissionManager: PermissionManager

    var body: some View {
        if permissionManager.isCameraDenied {
            PermissionDeniedView(
                permissionType: .camera,
                onOpenSettings: PermissionManager.openSystemSettings
            )
        } else {
            CameraSectionView(videoManager: videoManager)
        }
    }
}

enum AccordionSection {
    case audioOutput
    case audioInput
    case camera
}
