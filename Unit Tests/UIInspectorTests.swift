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

import XCTest
@testable import KEDebugKit

// swiftlint:disable implicitly_unwrapped_optional

class UIInspectorTests: XCTestCase {

	private var inspector: UIInspector!

	private var view: UIView!
	private var leftSubview: UIView!
	private var subviewOfLeftSubview: UIView!
	private var centerSubview: UIView!
	private var rightSubview: UIView!
	private var imageView: UIImageView!
	private var label: UILabel!

    override func setUpWithError() throws {
		try super.setUpWithError()

		inspector = UIInspector()

		view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

		leftSubview = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 100))
		view.addSubview(leftSubview)

		subviewOfLeftSubview = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
		leftSubview.addSubview(subviewOfLeftSubview)

		imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
		subviewOfLeftSubview.addSubview(imageView)

		centerSubview = UIView(frame: CGRect(x: 0, y: 30, width: 100, height: 50))
		view.addSubview(centerSubview)

		rightSubview = UIView(frame: CGRect(x: 80, y: 0, width: 50, height: 100))
		view.addSubview(rightSubview)

		label = UILabel(frame: CGRect(x: 10, y: 10, width: 30, height: 20))
		rightSubview.addSubview(label)
    }

	func testFindNothingAtEmptySpot() {
		let result = inspector.topmostView(at: CGPoint(x: -1, y: -1), in: view)
		XCTAssertNil(result)
	}

	func testFindOnlyViewAtSpotWithNoSubviews() {
		let result = inspector.topmostView(at: CGPoint(x: 40, y: 0), in: view)
		XCTAssertEqual(result, view)
	}

	func testFindOnlyViewAtSpotWithNoSubviewsWithViewHavingNonZeroOrigin() {
		let result = inspector.topmostView(at: CGPoint(x: 1, y: 1), in: rightSubview)
		XCTAssertEqual(result, rightSubview)
	}

	func testFindSingleSubviewInNonZeroOriginSuperview() {
		let result = inspector.topmostView(at: CGPoint(x: 20, y: 20), in: rightSubview)
		XCTAssertEqual(result, label)
	}

	func testFindTopmostViewAtPointWithOverlappingSubviews() {
		let result = inspector.topmostView(at: CGPoint(x: 15, y: 40), in: view)
		XCTAssertEqual(result, centerSubview)
	}

	func testFindViewAtEdge() {
		let result = inspector.topmostView(at: .zero, in: view)
		XCTAssertEqual(result, subviewOfLeftSubview)
	}

	func testUIHierarchyWithNoSubviews() {
		let result = inspector.uiHierarchy(startingAt: label)
		XCTAssertEqual(result, UIHierarchy(rootItems: [.view(label, [])]))
	}

	func testSimpleUIHierarchy() {
		let result = inspector.uiHierarchy(startingAt: rightSubview)
		XCTAssertEqual(
			result,
			UIHierarchy(rootItems: [
				.view(rightSubview, [
					.view(label, []),
				]),
			])
		)
	}
}
