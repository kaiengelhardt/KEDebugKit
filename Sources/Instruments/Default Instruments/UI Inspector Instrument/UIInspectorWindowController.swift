//
//  Created by Kai Engelhardt on 16.09.21
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
import KEFoundation

protocol UIInspectorWindowControllerDelegate: AnyObject {

	func uiInspectorWindowConroller(
		_ windowController: UIInspectorWindowController,
		didPerformTapAtLocation location: CGPoint
	)
}

class UIInspectorWindowController: UIResponder {

	weak var delegate: UIInspectorWindowControllerDelegate?

	var isInspectingViews: Bool {
		get {
			window.isInspectingViews
		}
		set {
			window.isInspectingViews = newValue
			rootViewController.view.backgroundColor = isInspectingViews ? .systemBlue.withAlphaComponent(0.1) : .clear
		}
	}

	let window: UIInspectorWindow
	private let rootViewController = UIInspectorWindowRootViewController()

	init(windowSceneWrapper: WindowSceneWrapperProtocol) {
		window = UIInspectorWindow()
		super.init()
		setUpUI(windowSceneWrapper: windowSceneWrapper)
	}

	deinit {
		window.removeFromSuperview()
	}

	private func setUpUI(windowSceneWrapper: WindowSceneWrapperProtocol) {
		windowSceneWrapper.configureScene(on: window)
		window.bounds = windowSceneWrapper.screenBounds
		window.setFrameToBeNotEntirelyFullscreenToPreventThisWindowFromSwallowingStatusBarEvents()
		window.rootViewController = rootViewController
		window.makeKeyAndVisible()

		rootViewController.onTouchesEnded = { [weak self] touches, event in
			guard
				let self = self,
				let touch = touches.first
			else {
				return
			}

			let location = touch.location(in: self.window)
			self.delegate?.uiInspectorWindowConroller(self, didPerformTapAtLocation: location)
		}
	}
}

private class UIInspectorWindowRootViewController: UIViewController {

	var onTouchesEnded: ((Set<UITouch>, UIEvent?) -> Void)?

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		onTouchesEnded?(touches, event)
	}
}
