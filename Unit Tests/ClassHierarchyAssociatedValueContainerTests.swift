//
//  Created by Kai Engelhardt on 01.01.22
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

import XCTest
@testable import KEDebugKit

// swiftlint:disable implicitly_unwrapped_optional

class ClassHierarchyAssociatedValueContainerTests: XCTestCase {

	private var container: ClassHierarchyAssociatedValueContainer<String>!

	override func setUpWithError() throws {
		try super.setUpWithError()
		container = ClassHierarchyAssociatedValueContainer()
	}

	func testContainerDoesNotContainValueForClassThatWasNotAdded() {
		XCTAssertFalse(container.containsValue(for: UIView.self))
	}

	func testContainerContainsValueForClassThatWasAdded() {
		container.setValue("Test", for: UIView.self)
		XCTAssertTrue(container.containsValue(for: UIView.self))
	}

	func testSingleValueIsStored() {
		container.setValue("Test", for: UIView.self)
		XCTAssertEqual(container.value(for: UIView.self), "Test")
	}

	func testMultipleValuesAreStored() {
		container.setValue("Test 1", for: UIView.self)
		container.setValue("Test 2", for: UIResponder.self)

		XCTAssertEqual(container.value(for: UIView.self), "Test 1")
		XCTAssertEqual(container.value(for: UIResponder.self), "Test 2")
	}
}