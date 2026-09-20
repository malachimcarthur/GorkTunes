# GorkTunes

GorkTunes is an iPhone-focused Swift app designed for a clean, mobile-first music experience. The project is built to run on iPhone and is optimized for the device’s display, with a simple interface for listening to music and managing playback.

This repository contains the Swift source for the app and is intended for local development and sideload installation on a connected iPhone.

## What the app does

GorkTunes is designed to provide a lightweight music app experience on iPhone, including:

- A simple, readable interface for mobile playback
- iPhone-optimized layout and interaction
- Music playback focused on usability and accessibility
- Easy local development and testing on a physical device

The exact feature set may evolve as the project is developed, but the goal is to keep the experience focused, minimal, and easy to use on iPhone.

## Requirements

Before you build and install the app, make sure you have:

- MacOs computer with Xcode installed (only for development)
- An Apple ID (free or paid developer account works)
- Sideloadly installed on Windows if you are using the Windows-based sideload workflow: https://sideloadly.io/

## Project setup

1. Open the project in Xcode:
   - Open the `.xcodeproj` or `.xcworkspace` file in the repository
2. Select the app target
3. Set the signing team:
   - In Xcode, open the project settings
   - Select the app target
   - Under Signing & Capabilities, choose your Apple Developer account or team
4. Make sure the bundle identifier is unique:
   - Example: `com.yourname.GorkTunes`
5. Build the project:
   - Product > Build
6. If needed, resolve any missing dependencies or signing issues

## Installing with Sideloadly

Sideloadly is the easiest way to install the app on an iPhone without using the App Store or MacOs.

### Prerequisites for Sideloadly

- Windows PC
- Sideloadly installed from https://sideloadly.io/
- Apple ID credentials
- iPhone connected to the PC with a USB cable
- Trust the device in Finder/iTunes

### Steps

1. Download and install Sideloadly from https://sideloadly.io/
2. Download the latest unsigned `.ipa` file from the realeses section
3. Connect your iPhone to your computer via USB
4. Open Itunes to connect your iPhone to your computer
5. Open Sideloadly
6. Drag the `.ipa` file into Sideloadly
7. Enter your Apple ID email and password when prompted
8. Click Start or Install
9. Wait for Sideloadly to sign and install the app on your device

## Trusting the app on iPhone

After installation, you may need to trust the app certificate:

1. On your iPhone, open Settings
2. Go to Settings > General > VPN & Device Management
3. Find the developer app certificate associated with your Apple ID
4. Tap Trust
5. Return to the Home Screen and open GorkTunes

- Make sure you have developer mode activated on your iPhone

## Notes

- A free Apple Developer account can be used for testing, but certificates may need to be refreshed from time to time
- App stops launching after signing expires in a week, re-sign it with Sideloadly and it will keep app data

## License

This project is licensed under the MIT License.

## Contributing

If you want to improve the app:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on a physical iPhone device
5. Open a pull request with a clear description of the update

Sideloadly is the recommended installation method when you do not have access to MacOs with CodeX.
