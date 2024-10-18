//
//  VisibilityStateScrollView.swift
//  Divis
//
//  Created by Yasin Erdemli on 8/8/24.
//

import SwiftUI

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
