//
//  Created by Kai Engelhardt on 02.01.22
//  Copyright © 2022 Kai Engelhardt. All rights reserved.
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

class ViewInspector {

	func topmostView(at location: CGPoint, in view: UIView) -> UIView? {
		guard view.bounds.contains(location) else {
			return nil
		}
		for subview in view.subviews.reversed() {
			if let topmostView = topmostView(at: view.convert(location, to: subview), in: subview) {
				return topmostView
			}
		}
		return view
	}

	func uiHierarchy(startingAt participator: UIHierarchyParticipator) -> UIHierarchy {
		return UIHierarchy(rootItems: [participator.item])
	}
}

struct UIHierarchy: Equatable {

	let rootItems: [Item]
}

protocol UIHierarchyParticipator {

	var item: UIHierarchy.Item { get }
	var subitems: [UIHierarchy.Item] { get }
}

extension UIHierarchyParticipator {

	var subitems: [UIHierarchy.Item] {
		return []
	}
}

extension UIApplication: UIHierarchyParticipator {

	var item: UIHierarchy.Item {
		return .application(self, subitems)
	}

	var subitems: [UIHierarchy.Item] {
		return connectedScenes.map {
			$0.item
		}
	}
}

extension UIScene: UIHierarchyParticipator {

	var item: UIHierarchy.Item {
		return .scene(self, subitems)
	}
}

extension UIWindowScene {

	var subitems: [UIHierarchy.Item] {
		return windowsSortedByLevelAndKeyWindowStatus.map {
			$0.item
		}
	}

	private var windowsSortedByLevelAndKeyWindowStatus: [UIWindow] {
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

extension UIView: UIHierarchyParticipator {

	var item: UIHierarchy.Item {
		let viewItem: UIHierarchy.Item = .view(self, subitems)
		if let viewController = viewController {
			return .viewController(viewController, [viewItem])
		} else {
			return viewItem
		}
	}

	var subitems: [UIHierarchy.Item] {
		return subviews.map {
			$0.item
		}
	}

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
}

extension UIHierarchy {

	enum Item: Equatable, CustomDebugStringConvertible {

		case application(UIApplication, [Item])
		case scene(UIScene, [Item])
		case view(UIView, [Item])
		case viewController(UIViewController, [Item])

		public var debugDescription: String {
			var result = ""
			let object: AnyObject
			let subitems: [Item]
			switch self {
			case let .application(application, items):
				object = application
				subitems = items
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
}
