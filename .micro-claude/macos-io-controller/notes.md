# macOS IO Controller - Implementation Notes

## Session Log

_Notes, decisions, and discoveries made during implementation._

---

## Task #1: Project Setup & Configuration
**Status**: Completed
**Files**:
- Package.swift (created)
- macOSIOController/macOSIOController.entitlements (created)
- macOSIOController/App/ (folder created)
- macOSIOController/Views/ (folder created)
- macOSIOController/Models/ (folder created)
- macOSIOController/Services/ (folder created)
- macOSIOController/Utilities/ (folder created)
**Notes**:
- Created Swift Package Manager project instead of Xcode project for simpler management
- Using macOS 14+ as minimum deployment target (Sonoma)
- Entitlements configured for audio-input and camera permissions
- Linked CoreAudio, AVFoundation, and AppKit frameworks

## Task #2: Menu Bar Shell with MenuBarExtra
**Status**: Completed
**Files**:
- macOSIOController/App/macOSIOControllerApp.swift (created)
- macOSIOController/Views/ContentView.swift (created)
- macOSIOController/Views/AccordionView.swift (created)
**Notes**:
- Using SwiftUI MenuBarExtra with .window style for proper popover behavior
- Speaker icon (speaker.wave.2.fill) used as menu bar icon per plan
- Three accordion sections implemented: Audio Output, Audio Input, Camera
- AccordionSection enum controls which section is expanded (mutual exclusivity)
- Accordion component is reusable with generic content support

## Task #3: Data Models
**Status**: Completed
**Files**:
- macOSIOController/Models/AudioDevice.swift (created)
- macOSIOController/Models/VideoDevice.swift (created)
**Notes**:
- AudioDevice uses AudioDeviceID (UInt32) matching CoreAudio's type
- VideoDevice uses String id matching AVCaptureDevice's uniqueID
- Both models conform to Identifiable and Equatable
- Volume clamped to 0.0-1.0 range in AudioDevice initializer

## Task #4: Audio Device Manager (CoreAudio)
**Status**: Completed
**Files**:
- macOSIOController/Services/AudioDeviceManager.swift (created)
**Notes**:
- Implemented full CoreAudio wrapper using AudioObjectGetPropertyData/SetPropertyData
- Device enumeration filters by input/output streams to categorize devices
- Uses kAudioHardwareServiceDeviceProperty_VirtualMainVolume for volume control (from AudioToolbox)
- Mute control via kAudioDevicePropertyMute
- Default device switching via kAudioHardwarePropertyDefaultOutputDevice/InputDevice
- Property listeners set up for device list changes and default device changes
- Uses Combine's @Published for reactive updates to device lists
- Proper cleanup of listeners in deinit

## Task #5: Audio Output UI
**Status**: Completed
**Files**:
- macOSIOController/Views/DeviceRowView.swift (created)
- macOSIOController/Views/VolumeControlView.swift (created)
- macOSIOController/Views/AudioSectionView.swift (created)
- macOSIOController/Views/ContentView.swift (modified)
**Notes**:
- DeviceRowView displays individual audio devices with checkmark for default device
- VolumeControlView provides slider and mute toggle with dynamic icon based on volume level
- AudioSectionView combines device list and volume controls, reusable for input/output
- ContentView now integrates AudioDeviceManager with StateObject for state management
- Device selection immediately switches system default via AudioDeviceManager
- Volume changes apply to current default device in real-time

## Task #6: Audio Input UI
**Status**: Completed
**Files**:
- (Reuses components from Task #5)
**Notes**:
- AudioSectionView handles both input and output via isInput parameter
- Mic icons used for input devices, speaker icons for output
- Input volume control shows mic icon states (mic, mic.slash)
- Same DeviceRowView and VolumeControlView reused with input-specific styling

## Task #7: Video Device Manager (AVFoundation)
**Status**: Completed
**Files**:
- macOSIOController/Services/VideoDeviceManager.swift (created)
**Notes**:
- Uses AVCaptureDevice.DiscoverySession to enumerate cameras
- Supports built-in wide angle cameras and external cameras
- Observes AVCaptureDeviceWasConnected/Disconnected notifications for hot-plug support
- Tracks selected camera preference (macOS has no system-wide default camera API)
- Uses Combine @Published for reactive UI updates

## Task #8: Camera UI
**Status**: Completed
**Files**:
- macOSIOController/Views/CameraDeviceRowView.swift (created)
- macOSIOController/Views/CameraSectionView.swift (created)
- macOSIOController/Views/ContentView.swift (modified)
**Notes**:
- CameraDeviceRowView follows same pattern as DeviceRowView with camera icon
- CameraSectionView displays camera list, handles empty state
- ContentView now integrates VideoDeviceManager with StateObject
- Camera selection updates user preference tracked by VideoDeviceManager

## Task #9: Permission Handling
**Status**: Completed
**Files**:
- macOSIOController/Services/PermissionManager.swift (created)
- macOSIOController/Views/PermissionDeniedView.swift (created)
- macOSIOController/Views/ContentView.swift (modified)
- macOSIOController/Views/AccordionView.swift (modified)
**Notes**:
- PermissionManager wraps AVCaptureDevice authorization API for microphone and camera
- Permission requests triggered on first accordion expand (lazy permission prompting)
- PermissionDeniedView shown when permission is denied or restricted
- Deep link to System Settings Privacy section via x-apple.systempreferences URL scheme
- AccordionView extended with optional onExpand callback for triggering permission requests
- AudioInputSectionContent and CameraSectionContent wrapper views handle permission states

## Task #10: Edge Cases & Polish
**Status**: Completed
**Files**:
- macOSIOController/Models/VideoDevice.swift (modified)
- macOSIOController/Services/VideoDeviceManager.swift (modified)
- macOSIOController/Views/CameraDeviceRowView.swift (modified)
**Notes**:
- Device disconnection already handled via property listeners (AudioDeviceManager) and NotificationCenter observers (VideoDeviceManager)
- Empty states already display "No devices available" messages in section views
- Added isInUse property to VideoDevice model to track camera usage status
- VideoDeviceManager now checks isInUseByAnotherApplication for each camera
- CameraDeviceRowView displays "In Use" badge with orange styling when camera is active elsewhere
- Volume control failures fail silently per plan (no user-facing errors)

