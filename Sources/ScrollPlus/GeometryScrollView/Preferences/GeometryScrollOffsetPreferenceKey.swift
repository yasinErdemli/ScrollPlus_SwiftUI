//
//  GeometryScrollOffsetPreferenceKey.swift
//  GeneralReusableComponents
//
//  Created by Yasin Erdemli on 22/9/24.
//

import SwiftUI

// MARK: - GeometryScrollOffsetPreferenceKey

/// A preference key used to track the offset of the header during scrolling.
public struct GeometryScrollOffsetPreferenceKey: PreferenceKey {
    public static let defaultValue: CGFloat = .zero

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
