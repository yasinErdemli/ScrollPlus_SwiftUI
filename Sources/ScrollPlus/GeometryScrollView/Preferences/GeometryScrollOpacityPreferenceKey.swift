//
//  GeometryScrollOpacityPreferenceKey.swift
//  GeneralReusableComponents
//
//  Created by Yasin Erdemli on 23/9/24.
//

import SwiftUI

// MARK: - GeometryScrollOpacityPreferenceKey

/// A preference key used to track the opacity of the header during scrolling.
public struct GeometryScrollOpacityPreferenceKey: PreferenceKey {
    public static let defaultValue: CGFloat = .zero

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
