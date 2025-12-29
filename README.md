# 🍌 BananaMeter

**Measure Everything in Bananas!**

A fun iOS app that uses ARKit to measure real-world objects using the internet-famous "banana for scale" meme unit 🍌

## ✨ Features

- 🎯 **Point & Measure** - Tap to place measurement points in the real world
- 📏 **Multi-Unit Display** - Shows measurements in:
  - Bananas (based on standard 7-inch/17.78cm banana)
  - Meters
  - Centimeters  
  - Inches
- ✨ **AR Magic** - Real-time spatial tracking using ARKit and RealityKit
- 🎨 **Beautiful UI** - Vibrant yellow gradient theme with smooth animations
- 📱 **Native iOS** - Built entirely with SwiftUI

## 🚀 Getting Started

### Requirements

- Xcode 15.0 or later
- iOS 16.0 or later
- Physical iOS device with ARKit support (A9 chip or later)
  - iPhone 6s or newer
  - iPad (5th generation) or newer

⚠️ **Note:** ARKit requires a physical device and will NOT work in the iOS Simulator.

### Installation

1. **Open the project** in Xcode:
   ```bash
   open BananaMeter.xcodeproj
   ```

2. **Connect your iPhone/iPad** via USB

3. **Select your device** as the build destination in Xcode

4. **Build and Run** (⌘R)

## 📱 How to Use

1. **Launch the app** - You'll see the vibrant yellow home screen with an animated banana
2. **Tap "Start Measuring"** - Opens the AR camera view
3. **Point your device** at a flat surface and move it around to initialize AR tracking
4. **Tap once** to place the first measurement point
5. **Tap again** to place the second measurement point
6. **View the results** - Distance appears in bananas and other units!
7. **Tap the reset button** (↻) to measure again

## 🏗️ Project Structure

```
BananaMeter/
├── BananaMeterApp.swift        # App entry point
├── ContentView.swift            # Main view wrapper
├── HomeView.swift              # Home screen with yellow theme
├── ARMeasurementView.swift     # AR measurement screen
├── Info.plist                  # Camera permissions
└── Assets.xcassets/            # App icons and colors
```

## 🎨 Design Highlights

- **Animated Gradient Background** - Smooth flowing yellow/orange gradients
- **Bouncing Banana Animation** - Playful rotating banana emoji
- **Glassmorphic Cards** - Semi-transparent feature cards with backdrop blur
- **Real-time AR Visualization** - Yellow/orange markers and connecting lines in 3D space
- **Status Indicators** - Live tracking state feedback

## 🔧 Technical Details

- **Framework:** SwiftUI
- **AR Engine:** ARKit + RealityKit
- **Minimum iOS:** 16.0
- **Architecture:** MVVM with ObservableObject
- **Banana Standard:** 17.78cm (7 inches) - average banana length

## 📝 Permissions

The app requires camera access for AR features. Permission prompt is configured in `Info.plist`:
- **NSCameraUsageDescription:** "BananaMeter needs camera access to measure objects using AR"

## 🎯 Future Ideas

- [ ] Save measurement history
- [ ] Share measurements with friends
- [ ] Custom banana skins/themes
- [ ] Support for other fruit units (pineapples, watermelons!)
- [ ] Measurement screenshots with AR overlay

## 🍌 Why Bananas?

Because the internet decided bananas are the universal unit of measurement! [Know Your Meme: Banana for Scale](https://knowyourmeme.com/memes/banana-for-scale)

---

**Made with ❤️ and 🍌**
