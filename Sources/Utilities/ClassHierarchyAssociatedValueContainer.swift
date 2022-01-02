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

import Foundation

struct ClassHierarchyAssociatedValueContainer<Value: Equatable> {

	private var values: [String: Value] = [:]

	private func key(for `class`: AnyClass) -> String {
		return String(describing: `class`)
	}

	mutating func setValue(_ value: Value?, for `class`: AnyClass) {
		values[key(for: `class`)] = value
	}

	func value(for `class`: AnyClass) -> Value? {
		return values[key(for: `class`)]
	}

	func containsValue(for `class`: AnyClass) -> Bool {
		return values[key(for: `class`)] != nil
	}

	func valueHierarchy(startingAt `class`: AnyClass) -> [ClassValueAssociation<Value>] {
		var classValueAssociations: [ClassValueAssociation<Value>] = []
		var _currentClass: AnyClass? = `class`
		while let currentClass = _currentClass {
			if let value = value(for: currentClass) {
				let association = ClassValueAssociation(class: currentClass, value: value)
				classValueAssociations.append(association)
			}
			_currentClass = currentClass.superclass()
		}
		return classValueAssociations
	}
}

struct ClassValueAssociation<Value: Equatable>: Equatable {

	let `class`: AnyClass
	let value: Value

	var className: String {
		return String(describing: `class`)
	}

	static func == (lhs: ClassValueAssociation<Value>, rhs: ClassValueAssociation<Value>) -> Bool {
		return lhs.className == rhs.className && lhs.value == rhs.value
	}
}
