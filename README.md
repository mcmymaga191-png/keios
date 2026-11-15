# Storefront Switcher

Minimal SwiftUI Xcode project for iOS 15.0+ / arm64.

## What it does
- Lets you select one of four Storefront IDs.
- Runs `/var/jb/usr/bin/appstorectl storefront <ID>` directly on the jailbroken device.
- Displays stdout/stderr and the process exit code.

## Build
1. Open `StorefrontSwitcher.xcodeproj` in Xcode on a Mac.
2. Select the `StorefrontSwitcher` target and your signing team.
3. Build for a physical iPhone (arm64).
4. Export/install through your TrollStore workflow. A normal App Store-signed build may remain sandboxed and will not have access to `/var/jb`.

## Important
This project is source code, not a prebuilt IPA. An IPA must be compiled and packaged with an Apple iOS SDK. The execution approach also depends on TrollStore/jailbreak permissions allowing the app to spawn `/var/jb/usr/bin/appstorectl`.

If your `appstorectl` binary is at a different path, change `executable` in `ContentView.swift`.
