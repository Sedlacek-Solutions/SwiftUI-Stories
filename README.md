# SwiftUI-Stories

A SwiftUI package that provides a custom tab view with progress tracking functionality. <br>
Each tab can have its own duration and automatically advances when completed.

## Features

- 🔄 Automatic progress tracking for each tab
- ⏱️ Customizable duration for each tab
- 👆 Gesture-based navigation (tap left/right)
- 📱 Swipe between tabs
- ⏸️ Long press to pause progress
- 📱 Full SwiftUI implementation
- 🔄 Circular navigation (wraps around)

## Requirements

- iOS 17.0+
- Swift 6+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add SwiftUI-Stories to your project through Xcode:

1. File > Add Packages
2. Enter package URL: ```https://github.com/Sedlacek-Solutions/ProgressTabView.git```
3. Select version requirements
4. Click Add Package

## Usage

1. First, create your tab content by conforming to `ProgressTabContent`:

```swift
import Stories
import SwiftUI

enum ProgressTab: ProgressTabContent, CaseIterable {
    case first
    case second
    case third

    var totalTime: TimeInterval {
        switch self {
        case .first: 3
        case .second: 6
        case .third: 9
        }
    }

    var body: some View {
        Group {
            switch self {
            case .first: Text("1")
            case .second: Text("2")
            case .third: Text("3")
            }
        }
        .font(.largeTitle)
    }
}
```

2. Then, use `ProgressTabView` in your SwiftUI view:

```swift
import Stories
import SwiftUI

struct ContentView: View {
    var body: some View {
        ProgressTabView(tabs: ProgressTab.allCases)
    }
}
```

## Interaction

- Swipe left or right to navigate between tabs
- Tap the right side of a tab to advance to the next tab
- Tap the left side of a tab to go back to the previous tab
- Long press to pause the progress timer
- Release long press to resume the timer

## Customization

You can customize the progress increment amount when initializing the view:

```swift
ProgressTabView(
    tabs: tabs,
    incrementAmount: 0.05 // Updates every 0.05 seconds
)
```
