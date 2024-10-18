//
//  GeometryHeaderView.swift
//  GeneralReusableComponents
//
//  Created by Yasin Erdemli on 22/9/24.
//

import SwiftUI

struct GeometryHeaderView<Header: View>: View {
    let header: () -> Header
    let headerHeightCalculator: (CGFloat) -> Void
    var body: some View {
        header()
            .background {
                GeometryReader { proxy in
                    let height = proxy.safeAreaInsets.top + proxy.frame(in: .global).height
                    Color.clear
                        .task {
                            headerHeightCalculator(height)
                        }
                        .onChange(of: height) {
                            headerHeightCalculator($1)
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
