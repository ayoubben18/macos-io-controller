import SwiftUI

struct VolumeControlView: View {
    @Binding var volume: Float
    @Binding var isMuted: Bool
    let isInput: Bool
    let onVolumeChange: (Float) -> Void
    let onMuteToggle: () -> Void

    private var volumeIconName: String {
        if isMuted || volume == 0 {
            return isInput ? "mic.slash" : "speaker.slash"
        } else if volume < 0.33 {
            return isInput ? "mic" : "speaker.wave.1"
        } else if volume < 0.66 {
            return isInput ? "mic" : "speaker.wave.2"
        } else {
            return isInput ? "mic" : "speaker.wave.3"
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onMuteToggle) {
                Image(systemName: volumeIconName)
                    .frame(width: 20)
                    .foregroundColor(isMuted ? .red : .primary)
            }
            .buttonStyle(.plain)
            .help(isMuted ? "Unmute" : "Mute")

            Slider(
                value: Binding(
                    get: { Double(volume) },
                    set: { newValue in
                        volume = Float(newValue)
                        onVolumeChange(Float(newValue))
                    }
                ),
                in: 0...1
            )
            .controlSize(.small)

            Text("\(Int(volume * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 36, alignment: .trailing)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}
