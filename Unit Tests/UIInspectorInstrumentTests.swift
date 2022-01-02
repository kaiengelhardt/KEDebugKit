//
//  Created by Kai Engelhardt on 17.11.21
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

// swiftlint:disable implicitly_unwrapped_optional

import XCTest
@testable import KEDebugKit

class UIInspectorInstrumentTests: XCTestCase {

	private var instrumentCenter: InstrumentCenter!
	private var instrumentSession: InstrumentSession!
	private var instrument: UIInspectorInstrument!

    override func setUpWithError() throws {
		try super.setUpWithError()

		instrumentCenter = InstrumentCenter()
		let screenBounds = CGRect(x: 0, y: 0, width: 1_024, height: 768)
		let window = UIWindow(frame: screenBounds)
		let windowSceneWrapper = MockWindowSceneWrapper(windows: [window], screenBounds: screenBounds)
		instrumentSession = InstrumentSession(
			windowSceneWrapper: windowSceneWrapper,
			instrumentCenter: instrumentCenter
		)
		instrument = UIInspectorInstrument()
		instrumentCenter.addInstrument(instrument)
	}

	func testWindowControllerIsCreatedForInstrumentSession() {
		XCTAssertNotNil(instrument.windowControllers[instrumentSession])
	}

	func testWindowControllerIsRemovedWhenInstrumentIsRemoved() {
		instrumentCenter.removeInstrument(instrument)
		XCTAssertNil(instrument.windowControllers[instrumentSession])
	}

	func testNoWindowControllerIsInspectingViewsInitially() {
		let noWindowControllerIsInspectingViews = instrument.windowControllers.values
			.allSatisfy { windowController in
				!windowController.isInspectingViews
			}
		XCTAssertTrue(noWindowControllerIsInspectingViews)
	}

	func testAllWindowControllersAreInspectingViewsAfterBeginningInspecting() {
		instrument.beginInspecting()
		let allWindowControllersAreInspectingViews = instrument.windowControllers.values
			.allSatisfy { windowController in
				windowController.isInspectingViews
			}
		XCTAssertTrue(allWindowControllersAreInspectingViews)
	}

	func testNoWindowControllerIsInspectingViewsAfterEndingInspecting() {
		instrument.beginInspecting()
		instrument.endInspecting()
		let noWindowControllerIsInspectingViews = instrument.windowControllers.values
			.allSatisfy { windowController in
				!windowController.isInspectingViews
			}
		XCTAssertTrue(noWindowControllerIsInspectingViews)
	}
}
