//
//  Created by Kai Engelhardt on 08.08.21.
//  Copyright © 2021 Kai Engelhardt. All rights reserved.
//
//  Distributed under the permissive MIT license
//  Get the latest version from here:
//
//  https://github.com/kaiengelhardt/KEDebugKit
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

class PassthroughWindow: UIWindow {

	var onLayoutSubviews: ((UIWindow) -> Void)?

	private static var obfuscatedCanAffectStatusBarAppearanceSelector: Selector {
		return Selector(["_can", "Affect", "Status", "Bar", "Appearance"].joined())
	}

	init() {
		Self.swizzleCanAffectStatusBarAppearanceIfNeeded()
		super.init(frame: .zero)
		backgroundColor = nil
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	private static func swizzleCanAffectStatusBarAppearanceIfNeeded() {
		DispatchQueue.once {
			swizzleCanAffectStatusBarAppearance()
		}
	}

	private static func swizzleCanAffectStatusBarAppearance() {
		// Currently the way UIKit determines which view controller should control the status bar appearance, i.e.
		// `preferStatusBarHidden` and friends, is pretty lame. The view controller needs to be in the front most,
		// full-frame window which returns `true` from `_canAffectStatusBarAppearance`. "full-frame" in this context
		// means that the window has the same frame as its associated `UIWindowScene`. When adding auxiliary windows
		// on top of the main app window, this behavior is usually undesired.
		//
		// My original workaround for this was to set the frame of auxiliary windows to be 1 point less in height
		// than its `UIScreen`. Unfortunately this proved to be problematic, since now the auxiliary window was not
		// being resized properly, when putting the app into split-screen on the iPad. Scene frame changes are only
		// propagated for full-frame windows.
		//
		// The only viable workaround for now is to swizzle `_canAffectStatusBarAppearance` with an implementation that
		// returns `false`.

		guard let originalMethod = class_getInstanceMethod(
			self,
			obfuscatedCanAffectStatusBarAppearanceSelector
		) else {
			return
		}
		guard let replacementMethod = class_getInstanceMethod(
			self,
			#selector(canAffectStatusBarAppearanceReplacement)
		) else {
			return
		}
		method_exchangeImplementations(originalMethod, replacementMethod)
	}

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

	@objc
	private func canAffectStatusBarAppearanceReplacement() -> Bool {
		return false
	}
}
