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

// swiftlint:disable implicitly_unwrapped_optional

import XCTest
@testable import KEDebugKit

class InstrumentSessionTests: XCTestCase {

	private var instrumentCenter: InstrumentCenter!
	private var instrumentSession: InstrumentSession!

	override func setUpWithError() throws {
		try super.setUpWithError()

		instrumentCenter = InstrumentCenter()
		let mockWindowSceneWrapper = MockWindowSceneWrapper()
		instrumentSession = InstrumentSession(
			windowSceneWrapper: mockWindowSceneWrapper,
			instrumentCenter: instrumentCenter
		)
	}

	func testCurrentlyShownInstrumentIsLastSelectedInstrumentWhenAddingFirstInstrument() {
		let instrument = MockInstrument()

		instrumentCenter.addInstrument(instrument)

		XCTAssertIdentical(instrumentSession.currentlyShownInstrument, instrumentCenter.defaultInstrument)
	}

	func testCurrentlyShownInstrumentIsLastSelectedInstrumentWhenSettingTheCurrentInstrument() {
		let instrument1 = MockInstrument()
		let instrument2 = MockInstrument()
		let instrument3 = MockInstrument()

		instrumentCenter.addInstrument(instrument1)
		instrumentCenter.addInstrument(instrument2)
		XCTAssertIdentical(instrumentSession.currentlyShownInstrument, instrumentCenter.defaultInstrument)
		XCTAssertIdentical(instrumentSession.currentlyShownInstrument, instrument1)

		instrumentSession.currentlyShownInstrument = instrument2
		XCTAssertIdentical(instrumentSession.currentlyShownInstrument, instrumentCenter.defaultInstrument)
		XCTAssertIdentical(instrumentSession.currentlyShownInstrument, instrument2)

		instrumentCenter.addInstrument(instrument3)
		XCTAssertIdentical(instrumentSession.currentlyShownInstrument, instrumentCenter.defaultInstrument)
		XCTAssertIdentical(instrumentSession.currentlyShownInstrument, instrument2)

		instrumentSession.currentlyShownInstrument = instrument3
		XCTAssertIdentical(instrumentSession.currentlyShownInstrument, instrumentCenter.defaultInstrument)
		XCTAssertIdentical(instrumentSession.currentlyShownInstrument, instrument3)
	}

	func testInstrumentDidBecomeActive() {
		let instrument1 = MockInstrument()
		let instrument2 = MockInstrument()

		instrumentCenter.addInstrument(instrument1)
		instrumentCenter.addInstrument(instrument2)

		XCTAssertEqual(instrument1.didBecomeActiveInSessionCallCount, 1)
		XCTAssertEqual(instrument1.didResignActiveInSessionCallCount, 0)
		XCTAssertEqual(instrument2.didBecomeActiveInSessionCallCount, 0)
		XCTAssertEqual(instrument2.didResignActiveInSessionCallCount, 0)

		instrument1.resetTestVariables()
		instrumentSession.currentlyShownInstrument = instrument2

		XCTAssertEqual(instrument1.didBecomeActiveInSessionCallCount, 0)
		XCTAssertEqual(instrument1.didResignActiveInSessionCallCount, 1)
		XCTAssertEqual(instrument2.didBecomeActiveInSessionCallCount, 1)
		XCTAssertEqual(instrument2.didResignActiveInSessionCallCount, 0)
	}

	func testInstruemntDidResignActiveAfterItHasBeenRemovedFromInstrumentCenter() {
		let instrument = MockInstrument()
		instrumentCenter.addInstrument(instrument)

		XCTAssertEqual(instrument.didBecomeActiveInSessionCallCount, 1)
		XCTAssertEqual(instrument.didResignActiveInSessionCallCount, 0)

		instrumentCenter.removeInstrument(instrument)

		XCTAssertEqual(instrument.didBecomeActiveInSessionCallCount, 1)
		XCTAssertEqual(instrument.didResignActiveInSessionCallCount, 1)
	}

	func testInstrumentViewControllerIsCachedPerSession() {
		let otherInstrumentSession = InstrumentSession(
			windowSceneWrapper: MockWindowSceneWrapper(),
			instrumentCenter: instrumentCenter
		)
		let instrument = MockInstrument()
		instrumentCenter.addInstrument(instrument)

		let viewController1 = instrumentSession.viewController(for: instrument)
		let viewController2 = instrumentSession.viewController(for: instrument)
		let otherViewController1 = otherInstrumentSession.viewController(for: instrument)
		let otherViewController2 = otherInstrumentSession.viewController(for: instrument)

		XCTAssertIdentical(viewController1, viewController2)
		XCTAssertIdentical(otherViewController1, otherViewController2)
		XCTAssertNotIdentical(viewController1, otherViewController1)
	}

	func testViewControllersAreOnlyCreatedIfInstrumentIsInInstrumentCenter() {
		let otherInstrumentSession = InstrumentSession(
			windowSceneWrapper: MockWindowSceneWrapper(),
			instrumentCenter: instrumentCenter
		)
		let instrument = MockInstrument()

		let viewController1 = instrumentSession.viewController(for: instrument)
		let otherViewController1 = otherInstrumentSession.viewController(for: instrument)

		XCTAssertNil(viewController1)
		XCTAssertNil(otherViewController1)

		instrumentCenter.addInstrument(instrument)

		let viewController2 = instrumentSession.viewController(for: instrument)
		let otherViewController2 = otherInstrumentSession.viewController(for: instrument)

		XCTAssertNotNil(viewController2)
		XCTAssertNotNil(otherViewController2)

		instrumentCenter.removeInstrument(instrument)

		let viewController3 = instrumentSession.viewController(for: instrument)
		let otherViewController3 = otherInstrumentSession.viewController(for: instrument)

		XCTAssertNil(viewController3)
		XCTAssertNil(otherViewController3)
	}

	func testViewControllersArePurgedWhenCorrespondingInstrumentIsRemovedFromCenter() {
		let instrument = MockInstrument()
		instrumentCenter.addInstrument(instrument)
		weak var viewController = instrumentSession.viewController(for: instrument)

		XCTAssertNotNil(viewController)

		instrumentCenter.removeInstrument(instrument)

		XCTAssertNil(viewController)
	}
}
