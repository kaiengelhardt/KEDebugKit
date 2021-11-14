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
		let instrument = UserDefaultsInstrument()

		instrumentCenter.addInstrument(instrument)

		XCTAssertSame(instrumentSession.currentlyShownInstrument, instrumentCenter.defaultInstrument)
	}

	func testCurrentlyShownInstrumentIsLastSelectedInstrumentWhenSettingTheCurrentInstrument() {
		let instrument1 = UserDefaultsInstrument()
		let instrument2 = UserDefaultsInstrument()
		let instrument3 = UserDefaultsInstrument()

		instrumentCenter.addInstrument(instrument1)
		instrumentCenter.addInstrument(instrument2)
		XCTAssertSame(instrumentSession.currentlyShownInstrument, instrumentCenter.defaultInstrument)
		XCTAssertSame(instrumentSession.currentlyShownInstrument, instrument1)

		instrumentSession.currentlyShownInstrument = instrument2
		XCTAssertSame(instrumentSession.currentlyShownInstrument, instrumentCenter.defaultInstrument)
		XCTAssertSame(instrumentSession.currentlyShownInstrument, instrument2)

		instrumentCenter.addInstrument(instrument3)
		XCTAssertSame(instrumentSession.currentlyShownInstrument, instrumentCenter.defaultInstrument)
		XCTAssertSame(instrumentSession.currentlyShownInstrument, instrument2)

		instrumentSession.currentlyShownInstrument = instrument3
		XCTAssertSame(instrumentSession.currentlyShownInstrument, instrumentCenter.defaultInstrument)
		XCTAssertSame(instrumentSession.currentlyShownInstrument, instrument3)
	}
}
