# SwiftUI ScrollView Library

A SwiftUI library that provides two enhanced `ScrollView` components:
1. `VisibilityStateScrollView`: Changes visibility state based on scroll velocity.
2. `GeometryScrollView`: Dynamically changes header opacity and offset, with optional preference keys for use elsewhere in your app.

## Features
- **`VisibilityStateScrollView`:**
  - Changes view visibility (visible/hidden) based on scroll velocity.
  - Customize velocity thresholds to hide and show content.

- **`GeometryScrollView`:**
  - Adjusts header opacity and position based on scroll offset.
  - Provides PreferenceKeys for header offset and opacity values.
  - Can be used with or without a header, allowing flexible customization.

## Requirements
- iOS 17.0+
- Swift 6.0+
- SwiftUI framework




## Installation

### Swift Package Manager

1. In Xcode, select **File > Add Packages**.
2. Enter the GitHub repository URL: `https://github.com/yasinErdemli/ScrollPlus_SwiftUI.git`.
3. Choose the library and click **Add Package**.

## Usage

### 1. `VisibilityStateScrollView`

https://github.com/user-attachments/assets/07c48d77-a675-46a0-b7d0-07df24a324e0

`VisibilityStateScrollView` changes the visibility of views based on how fast the user scrolls. Set thresholds for hiding and showing the content.

```swift
import ScrollPlus

struct ContentView: View {
    @State private var visibility: Visibility = .visible

    var body: some View {
        VisibilityStateScrollView(visibility: $visibility) {
            VStack {
                ForEach(1..<10) { _ in
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 200)
                }
            }
        }
        .toolbar(visibility, for: .tabBar)
        .animation(.smooth, value: visibility)
    }
}
```
#### **Parameters:**
  - visibility: Bind to control visibility state (.visible or .hidden).
  - hideVelocity: Velocity threshold for hiding content.
  - showVelocity: Velocity threshold for showing content.
### 2. `GeometryScrollView`

https://github.com/user-attachments/assets/59933a1b-054a-4b8c-b6e0-83b5c509d251


`GeometryScrollView` adjusts the opacity and offset of the header based on the scroll position. It can be used with a header or without, relying on PreferenceKeys to share values with other views.
*With a Header:*
```swift
GeometryScrollView {
    VStack {
        ForEach(1..<30) { _ in
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 200)
        }
    }
    .padding(.horizontal)
} header: { opacity in
    HStack {
        Text("Hello")
        Spacer()
        Image(systemName: "xmark")
    }
    .font(.largeTitle)
    .padding()
    .background(.red.opacity(opacity))
}
```
You can also use it without a header, accessing scroll values with *PreferenceKeys*:
```swift
GeometryScrollView {
    VStack {
        ForEach(1..<20) { _ in
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 200)
        }
    }
}
.onPreferenceChange(GeometryScrollOffsetPreferenceKey.self) { offset in
    print("Scroll offset: \(offset)")
}
.onPreferenceChange(GeometryScrollOpacityPreferenceKey.self) { opacity in
    print("Header opacity: \(opacity)")
}
```
Even if you use header, you can still access values with *PreferenceKey* to be able to use it in other places you want some kind of synchronization.
#### Parameters:
  - content: The content to be displayed inside the scroll view.
  - header: A closure that returns a header view, with a CGFloat parameter representing the header's opacity. Optional; if not provided, the scroll view can be used without a header.
#### PreferenceKeys:
   * GeometryScrollOffsetPreferenceKey: Provides the current offset of the header.
   * GeometryScrollOpacityPreferenceKey: Provides the current opacity of the header.
