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

import XCTest
@testable import KEDebugKit

class InstrumentCenterTests: XCTestCase {

	func testDefaultInstrumentIsNoInstrument() {
		let instrumentCenter = InstrumentCenter()
		XCTAssert(instrumentCenter.defaultInstrument is NoInstrument)
	}

	func testDefaultInstrumentIsFirstInstrument() {
		let instrumentCenter = InstrumentCenter()
		let instrument = MockInstrument()
		instrumentCenter.addInstrument(instrument)
		XCTAssertIdentical(instrumentCenter.defaultInstrument, instrument)
	}

	func testLastSelectedInstrumentIsDefaultInstrument() {
		let instrumentCenter = InstrumentCenter()
		let instrument1 = MockInstrument()
		let instrument2 = MockInstrument()
		let instrument3 = MockInstrument()

		instrumentCenter.addInstrument(instrument1)
		instrumentCenter.addInstrument(instrument2)
		instrumentCenter.addInstrument(instrument3)

		XCTAssertIdentical(instrumentCenter.defaultInstrument, instrument1)

		instrumentCenter.setLastSelectedInstrument(instrument2)
		XCTAssertIdentical(instrumentCenter.defaultInstrument, instrument2)

		instrumentCenter.setLastSelectedInstrument(instrument3)
		XCTAssertIdentical(instrumentCenter.defaultInstrument, instrument3)
	}

	func testInstrumentsAreEmptyAfterInitialization() {
		let instrumentCenter = InstrumentCenter()
		XCTAssert(instrumentCenter.instruments.isEmpty)
	}

	func testInstrumentsAreAddedProperly() {
		let instrumentCenter = InstrumentCenter()
		let instrument1 = MockInstrument()
		let instrument2 = MockInstrument()

		instrumentCenter.addInstrument(instrument1)
		XCTAssert(instrumentCenter.instruments.count == 1)
		XCTAssertContainsIdentical(instrumentCenter.instruments, instrument1)

		instrumentCenter.addInstrument(instrument2)
		XCTAssert(instrumentCenter.instruments.count == 2)
		XCTAssertContainsIdentical(instrumentCenter.instruments, instrument1)
		XCTAssertContainsIdentical(instrumentCenter.instruments, instrument2)
	}

	func testInstrumentsAreRemovedProperly() {
		let instrumentCenter = InstrumentCenter()
		let instrument1 = MockInstrument()
		let instrument2 = MockInstrument()

		instrumentCenter.addInstrument(instrument1)
		instrumentCenter.addInstrument(instrument2)

		instrumentCenter.removeInstrument(instrument1)
		XCTAssert(instrumentCenter.instruments.count == 1)
		XCTAssertDoesNotContainIdentical(instrumentCenter.instruments, instrument1)

		instrumentCenter.removeInstrument(instrument2)
		XCTAssert(instrumentCenter.instruments.isEmpty)
	}

	func testDefaultInstrumentIsNoLongerDefaultInstrumentAfterItHasBeenRemoved() {
		let instrumentCenter = InstrumentCenter()
		let instrument1 = MockInstrument()
		let instrument2 = MockInstrument()

		instrumentCenter.addInstrument(instrument1)
		instrumentCenter.addInstrument(instrument2)

		XCTAssertSame(instrumentCenter.defaultInstrument, instrument1)

		instrumentCenter.removeInstrument(instrument1)

		XCTAssertSame(instrumentCenter.defaultInstrument, instrument2)

		instrumentCenter.removeInstrument(instrument2)

		XCTAssertTrue(instrumentCenter.defaultInstrument is NoInstrument)
	}

	func testDefaultInstrumentIsNoLongerDefaultInstrumentAfterItHasBeenRemovedAndItHasBeenTheLastSelectedInstrument() {
		let instrumentCenter = InstrumentCenter()
		let instrument1 = MockInstrument()
		let instrument2 = MockInstrument()

		instrumentCenter.addInstrument(instrument1)
		instrumentCenter.addInstrument(instrument2)

		instrumentCenter.setLastSelectedInstrument(instrument2)

		XCTAssertSame(instrumentCenter.defaultInstrument, instrument2)

		instrumentCenter.removeInstrument(instrument2)

		XCTAssertSame(instrumentCenter.defaultInstrument, instrument1)

		instrumentCenter.removeInstrument(instrument1)

		XCTAssertTrue(instrumentCenter.defaultInstrument is NoInstrument)
	}
}
