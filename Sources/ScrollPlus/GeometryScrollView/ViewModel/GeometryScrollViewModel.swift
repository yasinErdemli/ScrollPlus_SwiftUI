//
//  GeometryScrollViewModel.swift
//  GeneralReusableComponents
//
//  Created by Yasin Erdemli on 22/9/24.
//

import SwiftUI
import Observation
import AsyncAlgorithms

@MainActor
@Observable final class GeometryScrollViewModel {
    var naturalScrollOffset: CGFloat = .zero
    var lastNaturalOffset: CGFloat = .zero
    var isScrollingUp: Bool = false
    var headerGeoHeight: CGFloat = .zero
    var opacity: CGFloat = .zero
    var headerOffset: CGFloat = .zero
    var (detector, continuation) = AsyncStream.makeStream(of: CGFloat.self, bufferingPolicy: .bufferingNewest(2))

    func contentScrolled(oldValue: CGFloat, newValue: CGFloat, safeTop: CGFloat) {
        let isScrollingUp = oldValue < newValue
        headerOffset = min(max(0, newValue - lastNaturalOffset), safeTop + headerGeoHeight)
        naturalScrollOffset = newValue
        if isScrollingUp != self.isScrollingUp {
            lastNaturalOffset = naturalScrollOffset - headerOffset
        }
        self.opacity = viewOpacity()
    }

    func scrollValueChanged( _ value: CGFloat) {
        continuation.yield(value)
    }

    func calculateHeaderHeight(_ height: CGFloat) {
        headerGeoHeight = height
    }

    private func handleHeaderState() {
        if headerOffset != 0 && headerOffset != headerGeoHeight {
            withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                if headerOffset > (headerGeoHeight * 0.5) && naturalScrollOffset > headerGeoHeight {
                    headerOffset = headerGeoHeight
                } else {
                    headerOffset = 0
                }
                lastNaturalOffset = naturalScrollOffset - headerOffset
            }
        }
    }

    private func viewOpacity() -> CGFloat {
        interpolateBetween(1, and: 0, with: 35)
    }

    private func interpolateBetween(
        _ first: CGFloat,
        and second: CGFloat,
        with offset: CGFloat) -> CGFloat {
            let progress = min(max(naturalScrollOffset / offset, 0), 1)
            let returnValue = second + (first - second) * progress
            return returnValue
        }

    func bindToDetector() async {
        for await _ in detector.debounce(for: .seconds(0.3)) {
            handleHeaderState()
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
