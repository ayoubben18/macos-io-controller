import SwiftUI

@main
struct macOSIOControllerApp: App {
    var body: some Scene {
        MenuBarExtra("IO Controller", systemImage: "speaker.wave.2.fill") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
