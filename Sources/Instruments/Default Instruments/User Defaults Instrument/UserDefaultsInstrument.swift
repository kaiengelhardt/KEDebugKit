//
//  Created by Kai Engelhardt on 10.08.21
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
import KEFoundation
import Combine

public class UserDefaultsInstrument: NSObject, Instrument {

	enum Change {

		case added(key: String, value: Any)
		case updated(key: String, previousValue: Any, newValue: Any)
		case deleted(key: String, value: Any)
	}

	public let title = "User Defaults"

	@Published private(set) var userDefaultsDictionary: [String: Any] = [:]
	@Published private(set) var userDefaultsDictionaryDiff: [Change] = [] {
		didSet {
			print(userDefaultsDictionaryDiff)
		}
	}

	private let userDefaults: UserDefaults
	private let notificationObserver = NotificationObserver()

	public init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults
		super.init()
		setUpObserving()
	}

	private func setUpObserving() {
		userDefaultsDictionary = userDefaults.dictionaryRepresentation()

		notificationObserver.when(UserDefaults.didChangeNotification, object: userDefaults) { [weak self] _ in
			guard let self = self else {
				return
			}
			let newDictionary = self.userDefaults.dictionaryRepresentation()
			let oldDictionary = self.userDefaultsDictionary
			self.userDefaultsDictionary = newDictionary
			self.userDefaultsDictionaryDiff = self.diff(between: oldDictionary, and: newDictionary)
		}
	}

	public func makeViewController() -> UIViewController {
		return UserDefaultsInstrumentViewController(instrument: self)
	}

	private func diff(between previousDictionary: [String: Any], and newDictionary: [String: Any]) -> [Change] {
		let previousStringDictionary = stringRepresentationDictionary(for: previousDictionary)
		let newStringDictionary = stringRepresentationDictionary(for: newDictionary)

		let previousKeys = Array(previousDictionary.keys)
		let newKeys = Array(newDictionary.keys)
		let allKeys = [previousKeys, newKeys].flatMap { $0 }

		var diff: [Change] = []

		for key in allKeys {
			let previousValue = previousDictionary[key]
			let previousStringValue = previousStringDictionary[key]
			let newValue = newDictionary[key]
			let newStringValue = newStringDictionary[key]
			if
				let previousValue = previousValue,
				let newValue = newValue
			{
				if previousStringValue != newStringValue {
					diff.append(.updated(key: key, previousValue: previousValue, newValue: newValue))
				}
			} else if let previousValue = previousValue {
				diff.append(.deleted(key: key, value: previousValue))
			} else if let newValue = newValue {
				diff.append(.added(key: key, value: newValue))
			}
		}

		return diff
	}

	private func stringRepresentationDictionary(for dictionary: [String: Any]) -> [String: String] {
		var stringDictionary: [String: String] = [:]
		for (key, value) in dictionary {
			if let description = (value as? CustomStringConvertible)?.description {
				stringDictionary[key] = description
			} else {
				stringDictionary[key] = "<unknown>"
			}
		}
		return stringDictionary
	}
}
