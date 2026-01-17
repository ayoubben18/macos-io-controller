import SwiftUI

struct CameraSectionView: View {
    @ObservedObject var videoManager: VideoDeviceManager

    var body: some View {
        VStack(spacing: 0) {
            if videoManager.cameras.isEmpty {
                Text("No cameras available")
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding()
            } else {
                // Camera list
                ForEach(videoManager.cameras) { camera in
                    CameraDeviceRowView(device: camera) {
                        videoManager.selectCamera(camera)
                    }
                }
            }
        }
    }
}
