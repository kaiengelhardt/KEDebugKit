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
import KEFoundation

public class DebugWindowController: UIResponder {

	private let scene: UIWindowScene
	private let window: PassthroughWindow
	private let contentViewController = UIViewController()

	init(windowScene: UIWindowScene) {
		scene = windowScene
		window = PassthroughWindow(windowScene: windowScene)
		super.init()
		setUpUI()
	}

	private func setUpUI() {
		window.bounds = scene.screen.bounds
		window.setFrameToBeNotEntirelyFullscreenToPreventThisWindowFromSwallowingStatusBarEvents()
		window.rootViewController = contentViewController
		window.makeKeyAndVisible()
	}
}
