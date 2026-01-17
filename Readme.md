# macOS IO Controller

A native macOS menu bar app for quick audio and video device switching. No more digging through System Settings.

![Swift](https://img.shields.io/badge/Swift-5.9+-orange) ![macOS](https://img.shields.io/badge/macOS-14+-blue) ![License](https://img.shields.io/badge/license-MIT-green)

## Built with Ralph

This entire application was built in **5 Ralph iterations in one shot** using [micro-claude](https://github.com/ayoubben18/micro-claude) - and it works!

Ralph is an AI-powered development workflow that uses structured interrogation and task explosion to build complete features from scratch.

## Features

- **Audio Output Control** - Switch between speakers, headphones, and audio interfaces
- **Audio Input Control** - Switch between microphones and audio inputs
- **Camera Selection** - Switch between built-in and external cameras
- **Volume & Mute** - Adjust volume and mute/unmute for both input and output
- **Native macOS UI** - Looks and feels like a system app
- **Menu Bar Only** - No Dock icon, lives entirely in your menu bar

## Installation

### Build from Source

```bash
# Clone the repo
git clone https://github.com/ayoubben18/macos-io-controller.git
cd macos-io-controller

# Build
swift build -c release

# Run
.build/release/macOSIOController
```

### Run Directly

```bash
swift build && .build/debug/macOSIOController
```

## Usage

1. Click the **speaker icon** in your menu bar
2. Expand the section you want to control:
   - **Audio Output** - Select output device, adjust volume, mute
   - **Audio Input** - Select input device, adjust gain, mute
   - **Camera** - Select camera
3. Click any device to switch to it immediately

## Permissions

On first use, macOS will prompt for:
- **Microphone access** - Required to enumerate and control audio input devices
- **Camera access** - Required to enumerate cameras

If you denied permissions, click "Open System Settings" in the app to grant access.

## Run at Login

To have the app start automatically:

1. Build the release version:
   ```bash
   swift build -c release
   ```

2. Copy to Applications:
   ```bash
   cp .build/release/macOSIOController /Applications/
   ```

3. Go to **System Settings → General → Login Items** and add the app

## Stop the App

```bash
pkill macOSIOController
```

## Tech Stack

- **Swift 5.9+** with **SwiftUI**
- **CoreAudio** for audio device management
- **AVFoundation** for camera enumeration
- **MenuBarExtra** for native menu bar integration

## Credits

Built with [micro-claude (Ralph)](https://github.com/ayoubben18/micro-claude) - an AI-powered structured development workflow.

## License

MIT
