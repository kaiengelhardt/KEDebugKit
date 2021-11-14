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
import Combine

public class ViewInspectorInstrument: Instrument {

	public let title = "View Inspector"

	let viewInspectionResults = CurrentValueSubject<[ViewInspectionResult], Never>([])

	private var windowControllers: [InstrumentSession: ViewInspectorWindowController] = [:]
	private var instrumentSessions: [ViewInspectorWindowController: InstrumentSession] = [:]

	private var cancellables = Set<AnyCancellable>()

	public init() {}

	public func makeViewController() -> UIViewController {
		let navigationController = UINavigationController()
		let viewController = ViewInspectionResultViewController(instrument: self)
		navigationController.viewControllers = [viewController]
		return navigationController
	}

	public func didBecomeActive(in session: InstrumentSession) {
		let windowController = ViewInspectorWindowController(windowSceneWrapper: session.windowSceneWrapper)
		windowControllers[session] = windowController
		instrumentSessions[windowController] = session
		windowController.delegate = self
	}

	public func didResignActive(in session: InstrumentSession) {
		if let windowController = windowControllers[session] {
			instrumentSessions[windowController] = nil
		}
		windowControllers[session] = nil
	}

	func beginInspecting() {
		for windowController in windowControllers.values {
			windowController.isInspectingViews = true
		}
	}

	func endInspecting() {
		for windowController in windowControllers.values {
			windowController.isInspectingViews = false
		}
	}

	private func findViews(at location: CGPoint, in view: UIView) -> [UIView] {
		var allSubviews = [view]
		appendAllSubviews(of: view, to: &allSubviews)
		let filterdSubviews = allSubviews.filter { view in
			view.frame.contains(location)
		}
		return filterdSubviews
	}

	private func appendAllSubviews(of view: UIView, to queue: inout [UIView]) {
		queue.append(contentsOf: view.subviews)
		for subview in view.subviews {
			appendAllSubviews(of: subview, to: &queue)
		}
	}
}

extension ViewInspectorInstrument: ViewInspectorWindowControllerDelegate {

	func viewInspectorWindowConroller(
		_ windowController: ViewInspectorWindowController,
		didPerformTapAtLocation location: CGPoint
	) {
		endInspecting()

		guard let session = instrumentSessions[windowController] else {
			return
		}

		var allViews: [UIView] = []

		for window in session.windowSceneWrapper.windows {
			let convertedLocation = window.convert(location, from: windowController.window)
			let views = findViews(at: convertedLocation, in: window)
			allViews.append(contentsOf: views)
		}

		let results = allViews.map {
			ViewInspectionResult(view: $0)
		}

		viewInspectionResults.send(results)
	}
}
