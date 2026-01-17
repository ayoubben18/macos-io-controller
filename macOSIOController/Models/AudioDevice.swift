import Foundation
import CoreAudio

struct AudioDevice: Identifiable, Equatable {
    let id: AudioDeviceID
    let name: String
    let isInput: Bool
    let isOutput: Bool
    var volume: Float
    var isMuted: Bool
    var isDefault: Bool

    init(
        id: AudioDeviceID,
        name: String,
        isInput: Bool,
        isOutput: Bool,
        volume: Float = 1.0,
        isMuted: Bool = false,
        isDefault: Bool = false
    ) {
        self.id = id
        self.name = name
        self.isInput = isInput
        self.isOutput = isOutput
        self.volume = max(0.0, min(1.0, volume))
        self.isMuted = isMuted
        self.isDefault = isDefault
    }
}
