import Foundation

struct VideoDevice: Identifiable, Equatable {
    let id: String
    let name: String
    var isEnabled: Bool
    var isDefault: Bool
    var isInUse: Bool

    init(
        id: String,
        name: String,
        isEnabled: Bool = true,
        isDefault: Bool = false,
        isInUse: Bool = false
    ) {
        self.id = id
        self.name = name
        self.isEnabled = isEnabled
        self.isDefault = isDefault
        self.isInUse = isInUse
    }
}
