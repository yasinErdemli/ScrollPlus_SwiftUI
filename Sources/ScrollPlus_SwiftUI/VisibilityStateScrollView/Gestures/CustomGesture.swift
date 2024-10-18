//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 21/8/24.
//

import SwiftUI

struct CustomGesture: UIViewRepresentable {
    var onChange: (UIPanGestureRecognizer) -> Void
    private let gestureID: String = UUID().uuidString

    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let superView = uiView.superview?.superview,
               !(superView.gestureRecognizers?.contains(where: { $0.name == gestureID }) ?? false) {
                let gesture = UIPanGestureRecognizer(
                    target: context.coordinator,
                    action: #selector(context.coordinator.gestureChange))
                gesture.name = gestureID
                gesture.delegate = context.coordinator.delegate
                superView.addGestureRecognizer(gesture)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(onChange: onChange)
    }

    @MainActor
    class Coordinator {
        lazy var delegate: PanGestureDelegate = .init()
        var onChange: (UIPanGestureRecognizer) -> Void
        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }
        @objc func gestureChange(gesture: UIPanGestureRecognizer) {
            onChange(gesture)
        }
    }

    class PanGestureDelegate: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool { true }
    }
}
