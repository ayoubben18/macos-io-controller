import SwiftUI

struct PermissionDeniedView: View {
    let permissionType: PermissionType
    let onOpenSettings: () -> Void

    enum PermissionType {
        case microphone
        case camera

        var title: String {
            switch self {
            case .microphone: return "Microphone Access Required"
            case .camera: return "Camera Access Required"
            }
        }

        var message: String {
            switch self {
            case .microphone:
                return "To manage audio input devices, please allow microphone access in System Settings."
            case .camera:
                return "To manage camera devices, please allow camera access in System Settings."
            }
        }

        var iconName: String {
            switch self {
            case .microphone: return "mic.slash.fill"
            case .camera: return "camera.fill"
            }
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: permissionType.iconName)
                .font(.system(size: 28))
                .foregroundColor(.secondary)

            Text(permissionType.title)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(permissionType.message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: onOpenSettings) {
                Text("Open System Settings")
                    .font(.caption)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding()
    }
}
