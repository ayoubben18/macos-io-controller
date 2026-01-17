import SwiftUI

struct CameraDeviceRowView: View {
    let device: VideoDevice
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                Image(systemName: "camera")
                    .foregroundColor(.secondary)
                    .frame(width: 16)

                Text(device.name)
                    .lineLimit(1)
                    .truncationMode(.tail)

                if device.isInUse {
                    Text("In Use")
                        .font(.caption2)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(3)
                }

                Spacer()

                if device.isDefault {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(device.isDefault ? Color.accentColor.opacity(0.1) : Color.clear)
    }
}
