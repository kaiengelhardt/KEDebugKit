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

// swiftlint:disable force_try

import XCTest

func XCTAssertSame(
	_ expression1: @autoclosure () throws -> AnyObject,
	_ expression2: @autoclosure () throws -> AnyObject,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file,
	line: UInt = #line
) {
	let left = try! expression1()
	let right = try! expression2()
	if left !== right {
		let message = message()
		let messagePart = message.isEmpty ? "" : " - \(message)"
		XCTFail("\(left) is not the same as \(right)\(messagePart)", file: file, line: line)
	}
}

func XCTAssertContainsIdentical(
	_ arrayExpression: @autoclosure () throws -> [AnyObject],
	_ objectExpression: @autoclosure () throws -> AnyObject,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file,
	line: UInt = #line
) {
	let array = try! arrayExpression()
	let object = try! objectExpression()
	let arrayContainsObject = array.contains(where: {
		$0 === object
	})
	if !arrayContainsObject {
		let message = message()
		let messagePart = message.isEmpty ? "" : " - \(message)"
		XCTFail("\(object) is not the contained in array\(messagePart)", file: file, line: line)
	}
}
