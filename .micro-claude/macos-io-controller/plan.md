# macOS IO Controller - Implementation Plan

## Overview

A native macOS menu bar application built with Swift/SwiftUI that provides quick access to audio input, audio output, and camera device selection. The app lives in the system menu bar and offers a single-click dropdown interface with accordion sections for each device category, eliminating the need to navigate through System Settings.

## Problem Statement

Switching audio and video I/O devices on macOS requires navigating through System Settings, which is slow and disruptive during calls, recordings, or when frequently switching between setups. Users need instant access to device controls from the menu bar.

## Users & Personas

**Primary User:** Power users who frequently switch between audio/video devices (e.g., switching between headphones and speakers, internal mic and external mic, built-in camera and external webcam).

**Use Case Examples:**
- Joining a video call and quickly selecting the correct microphone
- Switching audio output from speakers to headphones
- Disabling camera before joining a meeting
- Switching between multiple audio interfaces for music production

## Functional Requirements

### User Flows

#### Flow 1: Switch Audio Output Device
1. User clicks menu bar icon
2. Dropdown appears with accordion sections
3. User clicks "Audio Output" accordion (or it's already expanded)
4. User sees list of available output devices with current one highlighted
5. User clicks desired device
6. System audio output switches immediately
7. Dropdown remains open for further adjustments

#### Flow 2: Adjust Output Volume
1. User clicks menu bar icon
2. User expands "Audio Output" accordion
3. User adjusts volume slider
4. System volume changes in real-time
5. User can click mute toggle to mute/unmute

#### Flow 3: Switch Audio Input Device
1. User clicks menu bar icon
2. User clicks "Audio Input" accordion to expand
3. User sees list of available input devices with current one highlighted
4. User clicks desired device
5. System audio input switches immediately

#### Flow 4: Switch Camera
1. User clicks menu bar icon
2. User clicks "Camera" accordion to expand
3. User sees list of available cameras with current one highlighted
4. User clicks desired camera
5. System default camera switches

#### Flow 5: Quick Camera Disable/Enable
1. User clicks menu bar icon
2. User clicks "Camera" accordion to expand
3. User clicks camera on/off toggle
4. Camera access is disabled/enabled system-wide

### Data Model

No persistent data storage required. All state is read from system APIs:

```
AudioDevice {
    id: AudioDeviceID (UInt32)
    name: String
    isInput: Bool
    isOutput: Bool
    volume: Float (0.0 - 1.0)
    isMuted: Bool
    isDefault: Bool
}

VideoDevice {
    id: String (uniqueID from AVCaptureDevice)
    name: String
    isEnabled: Bool
    isDefault: Bool
}

AppState {
    audioOutputDevices: [AudioDevice]
    audioInputDevices: [AudioDevice]
    cameras: [VideoDevice]
    currentOutputDevice: AudioDevice?
    currentInputDevice: AudioDevice?
    currentCamera: VideoDevice?
    expandedSection: AccordionSection? (enum: .audioOutput, .audioInput, .camera)
}
```

### API / Interfaces

**System APIs Used:**

1. **CoreAudio Framework** - Audio device enumeration and control
   - `AudioObjectGetPropertyData` - Get device list, names, volumes
   - `AudioObjectSetPropertyData` - Set default device, volume, mute
   - `AudioObjectAddPropertyListener` - Listen for device changes

2. **AVFoundation Framework** - Camera enumeration
   - `AVCaptureDevice.DiscoverySession` - Enumerate cameras
   - `AVCaptureDevice.default(for: .video)` - Get default camera

3. **AppKit/SwiftUI** - Menu bar integration
   - `NSStatusBar` / `MenuBarExtra` - Menu bar presence
   - `NSPopover` or SwiftUI native menu - Dropdown UI

### UI Components

```
MenuBarIcon
├── Dropdown Container
│   ├── AudioOutputAccordion
│   │   ├── AccordionHeader ("Audio Output" + expand/collapse icon)
│   │   └── AccordionContent
│   │       ├── DeviceList
│   │       │   └── DeviceRow (icon, name, checkmark if active)
│   │       ├── VolumeSlider
│   │       └── MuteToggle
│   │
│   ├── AudioInputAccordion
│   │   ├── AccordionHeader ("Audio Input" + expand/collapse icon)
│   │   └── AccordionContent
│   │       ├── DeviceList
│   │       │   └── DeviceRow (icon, name, checkmark if active)
│   │       ├── VolumeSlider
│   │       └── MuteToggle
│   │
│   └── CameraAccordion
│       ├── AccordionHeader ("Camera" + expand/collapse icon)
│       └── AccordionContent
│           ├── DeviceList
│           │   └── DeviceRow (icon, name, checkmark if active)
│           └── EnableDisableToggle
```

**Visual Specifications:**
- Native macOS styling (follows system appearance)
- Dark mode support (automatic via SwiftUI)
- Highlighted/selected state for active devices (checkmark or accent color)
- Standard macOS menu bar icon size (22x22 points)
- Dropdown width: ~280 points (standard menu width)

## Technical Requirements

### Tech Stack

| Component | Technology |
|-----------|------------|
| Language | Swift 5.9+ |
| UI Framework | SwiftUI |
| Target OS | macOS 26 (Tahoe) |
| Audio API | CoreAudio (AudioToolbox) |
| Video API | AVFoundation |
| Menu Bar | MenuBarExtra (SwiftUI native) |
| Build System | Xcode / Swift Package Manager |

### Project Structure

```
macos-io-controller/
├── macOSIOController/
│   ├── App/
│   │   └── macOSIOControllerApp.swift      # App entry point with MenuBarExtra
│   ├── Views/
│   │   ├── ContentView.swift                # Main dropdown view
│   │   ├── AccordionView.swift              # Reusable accordion component
│   │   ├── DeviceRowView.swift              # Single device row
│   │   ├── VolumeSliderView.swift           # Volume control
│   │   └── ToggleButtonView.swift           # Mute/enable toggles
│   ├── Models/
│   │   ├── AudioDevice.swift                # Audio device model
│   │   └── VideoDevice.swift                # Video device model
│   ├── Services/
│   │   ├── AudioDeviceManager.swift         # CoreAudio wrapper
│   │   └── VideoDeviceManager.swift         # AVFoundation wrapper
│   └── Utilities/
│       └── PermissionManager.swift          # Permission handling
├── macOSIOController.xcodeproj/
└── README.md
```

### Existing Patterns

N/A - New project, no existing codebase patterns.

### Performance

- Device list should load instantly (<100ms)
- Volume changes should be real-time (no perceptible delay)
- Device switching should be immediate
- App should use minimal memory (<50MB)
- No background CPU usage when menu is closed

### Security

- **Microphone Permission:** Required for input device enumeration
- **Camera Permission:** Required for camera enumeration and control
- **No network access:** App is fully offline
- **No data storage:** No sensitive data persisted
- **Sandboxing:** Can run sandboxed with appropriate entitlements

**Required Entitlements:**
```xml
<key>com.apple.security.device.audio-input</key>
<true/>
<key>com.apple.security.device.camera</key>
<true/>
```

## Integrations

- **System Audio:** Via CoreAudio framework
- **System Camera:** Via AVFoundation framework
- **macOS Menu Bar:** Via SwiftUI MenuBarExtra
- **System Settings:** Deep link to Privacy settings if permissions denied

## Edge Cases & Error Handling

| Scenario | Handling |
|----------|----------|
| Device disconnected while active | Auto-switch to system default device |
| No audio output devices | Show "No devices available" in section |
| No audio input devices | Show "No devices available" in section |
| No cameras available | Show "No cameras available" in section |
| Microphone permission denied | Show prompt with button to open System Settings |
| Camera permission denied | Show prompt with button to open System Settings |
| Device busy/in use by another app | Show device in list but indicate status |
| Volume change fails | Silently retry, no user-facing error |
| App launched without permission prompts yet | Request permissions on first accordion expand |

## Validation Rules

- Volume must be between 0.0 and 1.0
- Device IDs must be valid system device IDs
- Cannot select a device that doesn't exist
- Cannot adjust volume on a device that doesn't support it

## Anti-Requirements

The app should NOT:
- Auto-switch devices without user action (except when current device disconnects)
- Play test sounds when switching
- Run at startup by default
- Show notifications
- Have a Dock icon
- Store any user preferences or data
- Require internet connection
- Include analytics or telemetry
- Have a main application window (menu bar only)

## Success Criteria

### Acceptance Checklist

- [ ] App appears in menu bar with appropriate icon
- [ ] Clicking icon opens dropdown with three accordion sections
- [ ] Audio Output section:
  - [ ] Lists all available output devices
  - [ ] Highlights currently active device
  - [ ] Clicking device switches system output
  - [ ] Volume slider adjusts system volume
  - [ ] Mute toggle works
- [ ] Audio Input section:
  - [ ] Lists all available input devices
  - [ ] Highlights currently active device
  - [ ] Clicking device switches system input
  - [ ] Volume slider adjusts input gain
  - [ ] Mute toggle works
- [ ] Camera section:
  - [ ] Lists all available cameras
  - [ ] Highlights currently active camera
  - [ ] Clicking camera switches default camera
  - [ ] Enable/disable toggle works
- [ ] Permissions:
  - [ ] Prompts for microphone permission when needed
  - [ ] Prompts for camera permission when needed
  - [ ] Shows helpful message if permission denied
- [ ] Edge cases:
  - [ ] Handles device disconnect gracefully
  - [ ] Shows appropriate message when no devices available
- [ ] Visual:
  - [ ] Matches native macOS styling
  - [ ] Works in both light and dark mode

## Open Questions

1. **Menu bar icon:** What icon should represent the app? Options:
   - Speaker icon (focuses on audio)
   - Generic settings/sliders icon
   - Custom icon combining audio + video
   - *Decision:* Use SF Symbols speaker icon for now, can customize later

2. **Camera disable mechanism:** macOS doesn't have a true "disable camera" API. Options:
   - Use a virtual camera blocker (complex)
   - Simply close any camera sessions (limited)
   - Show camera on/off as visual indicator only
   - *Decision:* Research during implementation, may need to scope down

3. **Multiple simultaneous devices:** macOS supports aggregate devices. Should we:
   - Hide aggregate devices?
   - Show but not allow creation?
   - *Decision:* Show all devices the system shows, don't add aggregate device creation

---

## Implementation Order (Suggested)

1. **Project Setup** - Create Xcode project, configure entitlements
2. **Menu Bar Shell** - Get MenuBarExtra working with placeholder content
3. **Audio Device Manager** - CoreAudio integration for device enumeration
4. **Audio Output UI** - Accordion with device list, volume, mute
5. **Audio Input UI** - Similar to output, reuse components
6. **Video Device Manager** - AVFoundation integration
7. **Camera UI** - Accordion with device list, enable/disable
8. **Permission Handling** - Request and handle denied permissions
9. **Polish** - Edge cases, error handling, visual refinement
