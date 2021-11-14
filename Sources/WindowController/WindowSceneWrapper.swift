//
//  Created by Kai Engelhardt on 14.11.21
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

protocol WindowSceneWrapperProtocol {

	var windows: [UIWindow] { get }
	var screenBounds: CGRect { get }

	func configureScene(on window: UIWindow)
}

struct WindowSceneWrapper: WindowSceneWrapperProtocol {

	private let windowScene: UIWindowScene

	var windows: [UIWindow] {
		windowScene.windows
	}

	var screenBounds: CGRect {
		windowScene.screen.bounds
	}

	init(windowScene: UIWindowScene) {
		self.windowScene = windowScene
	}

	func configureScene(on window: UIWindow) {
		window.windowScene = windowScene
	}
}

struct MockWindowSceneWrapper: WindowSceneWrapperProtocol {

	var windows: [UIWindow] = []
	var screenBounds = CGRect.zero

	func configureScene(on window: UIWindow) {}
}
