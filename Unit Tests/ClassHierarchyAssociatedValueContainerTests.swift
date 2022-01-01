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

	func testContainerDoesNotContainValueForUnknwonClass() {
		XCTAssertFalse(container.containsValue(for: UIView.self))
	}

	func testContainerContainsValueForKnownClass() {
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

	func testValueIsRemoved() {
		container.setValue("Test 1", for: UIView.self)
		container.setValue(nil, for: UIView.self)
	}

	func testValueHierarchyForSingleClass() {
		container.setValue("Test", for: UIView.self)
		XCTAssertEqual(
			container.valueHierarchy(startingAt: UIView.self),
			[
				ClassValueAssociation(class: UIView.self, value: "Test"),
			]
		)
	}

	func testValueHierarchyForMultipleClasses() {
		container.setValue("Test 1", for: UIView.self)
		container.setValue("Test 2", for: UIButton.self)
		container.setValue("Test 3", for: UIControl.self)
		XCTAssertEqual(
			container.valueHierarchy(startingAt: UIButton.self),
			[
				ClassValueAssociation(class: UIButton.self, value: "Test 2"),
				ClassValueAssociation(class: UIControl.self, value: "Test 3"),
				ClassValueAssociation(class: UIView.self, value: "Test 1"),
			]
		)
	}

	func testValueHierarchyForMultipleClassesWithGaps() {
		container.setValue("Test 1", for: UIView.self)
		XCTAssertEqual(
			container.valueHierarchy(startingAt: UIButton.self),
			[
				ClassValueAssociation(class: UIView.self, value: "Test 1"),
			]
		)

		container.setValue("Test 2", for: UIButton.self)
		XCTAssertEqual(
			container.valueHierarchy(startingAt: UIButton.self),
			[
				ClassValueAssociation(class: UIButton.self, value: "Test 2"),
				ClassValueAssociation(class: UIView.self, value: "Test 1"),
			]
		)
	}

	func testValueHierarchyForMultipleUnrelatedClasses() {
		container.setValue("Test 1", for: UIView.self)
		container.setValue("Test 2", for: UIControl.self)
		container.setValue("Test 3", for: UIButton.self)
		container.setValue("Test 4", for: UISlider.self)
		container.setValue("Test 5", for: UIImage.self)
		XCTAssertEqual(
			container.valueHierarchy(startingAt: UIButton.self),
			[
				ClassValueAssociation(class: UIButton.self, value: "Test 3"),
				ClassValueAssociation(class: UIControl.self, value: "Test 2"),
				ClassValueAssociation(class: UIView.self, value: "Test 1"),
			]
		)

		XCTAssertEqual(
			container.valueHierarchy(startingAt: UISlider.self),
			[
				ClassValueAssociation(class: UISlider.self, value: "Test 4"),
				ClassValueAssociation(class: UIControl.self, value: "Test 2"),
				ClassValueAssociation(class: UIView.self, value: "Test 1"),
			]
		)

		XCTAssertEqual(
			container.valueHierarchy(startingAt: UIImage.self),
			[
				ClassValueAssociation(class: UIImage.self, value: "Test 5"),
			]
		)
	}

	func testValueHierarchyForUnknownClass() {
		XCTAssertEqual(container.valueHierarchy(startingAt: UIView.self), [])

		container.setValue("Test", for: UIButton.self)

		XCTAssertEqual(container.valueHierarchy(startingAt: UIView.self), [])
	}
}
