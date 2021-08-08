//
//  PassthroughWindow.swift
//  KEDebugKit
//
//  Created by Kai Engelhardt on 08.08.21.
//

import UIKit

class PassthroughWindow: UIWindow {

    var onLayoutSubviews: ((UIWindow) -> Void)?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self || view == rootViewController?.view {
            return nil
        } else {
            return view
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        onLayoutSubviews?(self)
    }
}
