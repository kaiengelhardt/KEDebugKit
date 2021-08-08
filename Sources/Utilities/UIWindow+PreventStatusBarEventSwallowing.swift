//
//  UIWindow+PreventStatusBarEventSwallowing.swift
//  KEDebugKit
//
//  Created by Kai Engelhardt on 08.08.21.
//

import UIKit

extension UIWindow {

    /// Sets the window frame to be almost fullscreen, but not entirely fullscreen.
    /// This prevents a bug where the status bar properties and some other UIKit
    /// mechanics don't work properly within the app window.
    /// This is because UIKit chooses the frontmost, fullscreen window to determine the status bar style.
    public func setFrameToBeNotEntirelyFullscreenToPreventThisWindowFromSwallowingStatusBarEvents(
        in screen: UIScreen = .main
    ) {
        var screenBounds = screen.bounds
        screenBounds.size.height -= 1
        frame = screenBounds
    }
}
