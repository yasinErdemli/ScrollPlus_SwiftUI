//
//  File.swift
//  GeneralReusableComponents
//
//  Created by Yasin Erdemli on 22/9/24.
//

import SwiftUI

/// A scrollable view with a dynamic header that adjusts its offset and opacity based on scroll position.
/// - Parameters:
///   - Content: The main content of the scroll view.
///   - Header: A custom header view that adjusts its position and opacity during scrolling.
struct GeometryContentView<Content: View>: View {
    let content: Content
    let height: CGFloat
    let scrollValueChanged: (CGFloat) -> Void
    let contentScrolled: (CGFloat, CGFloat) -> Void
    var body: some View {
        content
            .background {
                GeometryReader { proxy in
                    let maxHeight = abs(proxy.size.height - height)
                    let minY = max(min(-proxy.frame(in: .scrollView).minY, maxHeight), 0)
                    let scrollValue = -proxy.frame(in: .scrollView).origin.y
                    Color.clear
                        .onChange(of: minY) { oldValue, newValue in
                            contentScrolled(oldValue, newValue)
                        }
                        .onChange(of: scrollValue) {
                            scrollValueChanged($1)
                        }
                }
            }
    }
}

#Preview {
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
}
