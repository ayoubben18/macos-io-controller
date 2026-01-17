import SwiftUI

struct DeviceRowView: View {
    let device: AudioDevice
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                Image(systemName: device.isInput ? "mic" : "speaker.wave.2")
                    .foregroundColor(.secondary)
                    .frame(width: 16)

                Text(device.name)
                    .lineLimit(1)
                    .truncationMode(.tail)

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
