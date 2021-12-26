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

public struct ViewInspectionResult: Equatable {

	public let rootItems: [InspectedItem]
}

public enum InspectedItem: Equatable, CustomDebugStringConvertible {

	case scene(UIScene, [InspectedItem])
	case view(UIView, [InspectedItem])
	case viewController(UIViewController, [InspectedItem])

	public var debugDescription: String {
		var result = ""
		let object: AnyObject
		let subitems: [InspectedItem]
		switch self {
		case let .scene(scene, items):
			object = scene
			subitems = items
		case let .view(view, items):
			object = view
			subitems = items
		case let .viewController(viewController, items):
			object = viewController
			subitems = items
		}
		result += String(describing: type(of: object))
		if !subitems.isEmpty {
			result += "\n" + subitems
				.map { $0.debugDescription.indented(with: "  ") }
				.joined(separator: "\n")
		}
		return result
	}
}

protocol ViewInspectable {

	func inspect() -> InspectedItem
}

extension UIScene: ViewInspectable {

	func inspect() -> InspectedItem {
		if let windowScene = self as? UIWindowScene {
			let windowItems = windowScene
				.windowsSortedByLevelAndKeyWindowStatus
				.map {
					$0.inspect()
				}
			return .scene(self, windowItems)
		} else {
			return .scene(self, [])
		}
	}
}

extension UIWindowScene {

	fileprivate var windowsSortedByLevelAndKeyWindowStatus: [UIWindow] {
		return windows
			.sorted(by: {
				if $0.isKeyWindow == $1.isKeyWindow {
					return $0.windowLevel.rawValue > $1.windowLevel.rawValue
				} else {
					return $0.isKeyWindow
				}
			})
	}
}

extension UIView: ViewInspectable {

	private var viewController: UIViewController? {
		var current: UIResponder? = self
		var foundViewController: UIViewController?
		while current != nil {
			if let viewController = current as? UIViewController {
				if viewController.view === self {
					foundViewController = viewController
				}
				break
			}
			current = current?.next
		}
		return foundViewController
	}

	func inspect() -> InspectedItem {
		let subviewItems = subviews.map { $0.inspect() }
		let item = InspectedItem.view(self, subviewItems)
		if let viewController = viewController {
			return .viewController(viewController, [item])
		} else {
			return item
		}
	}
}
