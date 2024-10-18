//
//  File.swift
//
//
//  Created by Yasin Erdemli on 21/8/24.
//

import SwiftUI

/// A customizable `ScrollView` that dynamically adjusts the opacity and offset of a header
///  based on the scroll position.
///
/// This view is ideal for scenarios where the header needs to change its appearance
///  (like opacity and position) as the user scrolls.
/// Additionally, it uses `PreferenceKeys` to expose the current header offset and opacity,
/// which can be used elsewhere in the app.
///
/// ### Features:
/// - Supports dynamic changes to the header's opacity and offset based on the scroll position.
/// - Provides `GeometryScrollOffsetPreferenceKey`
///  and `GeometryScrollOpacityPreferenceKey` to expose the header's offset and
///  opacity for external usage.
/// - Can be used with or without a header, making it flexible for various scroll-based UI designs.
///
/// ### Example Usage:
///
/// With a header:
/// ```swift
///GeometryScrollView {
///    VStack {
///        ForEach(1..<30) { _ in
///            RoundedRectangle(cornerRadius: 20)
///                .frame(height: 200)
///        }
///    }
///    .padding(.horizontal)
///} header: { opacity in
///    HStack {
///        Text("Hello")
///       Spacer()
///       Image(systemName: "xmark")
///   }
///    .font(.largeTitle)
///    .padding()
///    .background(.red.opacity(opacity))
///}
/// ```
///
/// Without a header, using `PreferenceKeys`:
/// ```swift
/// GeometryScrollView {
///     VStack {
///         ForEach(1..<20) { _ in
///             RoundedRectangle(cornerRadius: 20)
///                 .frame(height: 200)
///         }
///     }
/// }
/// .onPreferenceChange(GeometryScrollOffsetPreferenceKey.self) { offset in
///     print("Scroll offset: \(offset)")
/// }
/// .onPreferenceChange(GeometryScrollOpacityPreferenceKey.self) { opacity in
///     print("Header opacity: \(opacity)")
/// }
/// ```
///
/// ### Parameters:
/// - `content`: A closure that returns the content to be displayed inside the scroll view.
/// - `header`: A closure that returns a header view, with a `CGFloat` parameter representing
/// the header's current opacity. Optional, defaults to `nil`.
///
/// ### PreferenceKeys:
/// - `GeometryScrollOffsetPreferenceKey`: Provides the current offset of the header,
///  useful for aligning UI elements with the scroll position.
/// - `GeometryScrollOpacityPreferenceKey`: Provides the current opacity of the header,
/// enabling custom effects based on scroll distance.
///
/// ### Note:
/// This view uses internal preference keys to communicate the scroll position and header opacity
///  to external views, making it a powerful tool for more complex scrolling interfaces.
public struct GeometryScrollView<Content: View, Header: View>: View {
    @State var viewModel = GeometryScrollViewModel()
    private let content: Content
    private let header: ((CGFloat) -> Header)?

    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: @escaping (CGFloat) -> Header
    ) {
        self.content = content()
        self.header = header
    }

    public var body: some View {
        GeometryReader { geo in
            let safeTop = geo.safeAreaInsets.top
            let height = geo.size.height
            ScrollView(.vertical) {
                GeometryContentView(
                    content: content,
                    height: height,
                    scrollValueChanged: viewModel.scrollValueChanged
                ) {
                    viewModel.contentScrolled(
                        oldValue: $0, newValue: $1, safeTop: safeTop)
                }
            }
            .coordinateSpace(.scrollView)
            .safeAreaInset(edge: .top, spacing: 0) {
                GeometryHeaderView {
                    header?(viewModel.opacity)
                } headerHeightCalculator: { height in
                    viewModel.calculateHeaderHeight(height + safeTop)
                }
                .offset(y: -viewModel.headerOffset)
            }
        }
        .background {
            Color.clear
                .preference(
                    key: GeometryScrollOffsetPreferenceKey.self,
                    value: viewModel.headerOffset
                )
                .preference(
                    key: GeometryScrollOpacityPreferenceKey.self,
                    value: viewModel.opacity)
        }
        .task {
            await viewModel.bindToDetector()
        }
    }
}

extension GeometryScrollView where Header == Never {
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = nil
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
