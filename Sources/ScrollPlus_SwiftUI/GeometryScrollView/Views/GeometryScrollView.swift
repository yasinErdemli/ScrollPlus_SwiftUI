//
//  File.swift
//
//
//  Created by Yasin Erdemli on 21/8/24.
//

import SwiftUI

public struct GeometryScrollView<Content: View, Header: View>: View {
    @State var viewModel = GeometryScrollViewModel()
    private let content: Content
    private let header: ((CGFloat) -> Header)?

    public init(@ViewBuilder content: () -> Content, @ViewBuilder header: @escaping (CGFloat) -> Header) {
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
                    scrollValueChanged: viewModel.scrollValueChanged) {
                    viewModel.contentScrolled(oldValue: $0, newValue: $1, safeTop: safeTop)
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
                .preference(key: GeometryScrollOffsetPreferenceKey.self, value: viewModel.headerOffset)
                .preference(key: GeometryScrollOpacityPreferenceKey.self, value: viewModel.opacity)
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
    } header: { opacity in
        HStack {
            Text("Hello")
            Spacer()
            Image(systemName: "xmark")
        }
        .padding(.horizontal)
        .background(.red.opacity(opacity))
    }
}
