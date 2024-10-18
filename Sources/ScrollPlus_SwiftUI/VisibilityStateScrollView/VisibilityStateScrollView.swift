//
//  VisibilityStateScrollView.swift
//  Divis
//
//  Created by Yasin Erdemli on 8/8/24.
//

import SwiftUI

/// A scrollable view that changes its visibility based on the vertical scroll velocity.
///
/// `VisibilityStateScrollView` provides a way to toggle the visibility of content (i.e., hide or show it) depending on the scroll speed. This is particularly useful for implementing dynamic behavior like hiding toolbars or other UI elements while scrolling up and revealing them while scrolling down.
///
/// ### Features:
/// - Automatically hides content when scrolling up fast, based on the configured velocity threshold.
/// - Reveals the content when scrolling down past a certain velocity threshold.
/// - Customizable velocity settings to control when the content hides and shows.
///
/// ### Example Usage:
/// ```swift
/// @State private var visibility: Visibility = .visible
///
/// var body: some View {
///     VisibilityStateScrollView(visibility: $visibility) {
///         VStack {
///             ForEach(1..<10) { _ in
///                 RoundedRectangle(cornerRadius: 20)
///                     .frame(height: 200)
///             }
///         }
///     }
///     .animation(.smooth, value: visibility)
/// }
/// ```
///
/// - `visibility`: A binding to a `Visibility` state, determining whether the content is `.visible` or `.hidden`.
/// - `hideVelocity`: The vertical velocity threshold at which the content hides (scrolling up).
/// - `showVelocity`: The vertical velocity threshold at which the content shows (scrolling down).
///
/// ### Parameters:
/// - `visibility`: A `Binding<Visibility>` that controls the visibility of the content. Can be `.visible` or `.hidden`.
/// - `hideVelocity`: A `CGFloat` representing the minimum upward scroll velocity required to hide the content. Default is `300`.
/// - `showVelocity`: A `CGFloat` representing the minimum downward scroll velocity required to show the content. Default is `200`.
/// - `content`: A closure that returns the view content to display inside the scroll view.
///
/// ### Customization:
/// The scroll velocity thresholds can be customized using the `hideVelocity` and `showVelocity` parameters to control how fast the user must scroll to trigger visibility changes.
public struct VisibilityStateScrollView<Content: View>: View {
    @Binding private var visibility: Visibility
    private let content: Content
    private let hideVelocity: CGFloat
    private let showVelocity: CGFloat
    public init(
        visibility: Binding<Visibility>,
        hideVelocity: CGFloat = 300,
        showVelocity: CGFloat = 200,
        content: @escaping () -> Content

    ) {
        self._visibility = visibility
        self.hideVelocity = hideVelocity
        self.showVelocity = showVelocity
        self.content = content()
    }
    public var body: some View {
        ScrollView(.vertical) {
            content
        }
        .background {
            CustomGesture(onChange: handleVisibilityState)
        }
    }
}

extension VisibilityStateScrollView {
    private func handleVisibilityState(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: gesture.view).y

        if -velocity > hideVelocity && visibility == .visible {
            visibility = .hidden

        } else {
            if velocity > showVelocity && visibility == .hidden {
                visibility = .visible
            }
        }
    }
}

#Preview {
    @Previewable @State var visibility: Visibility = .visible
    TabView {
        Group {
            VisibilityStateScrollView(visibility: $visibility) {
                VStack {
                    ForEach(1..<10) { _ in
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 200)
                    }
                }
            }
            .toolbar(visibility, for: .tabBar)
        }
        .tabItem {
            Label("Hello", systemImage: "house.fill")
        }
    }
    .animation(.smooth, value: visibility)
}
