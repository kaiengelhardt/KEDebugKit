//
//  Created by Kai Engelhardt on 12.08.21
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

import Foundation
import UIKit
import KEFoundation
import Combine

public class NotificationCenterInstrument: Instrument {

	public let title = "Notification Center"

	private let notificationCenter: NotificationCenter

	private let notificationObserver: NotificationObserver

	private let historySize: Int
	@Published private(set) var notificationHistory: [NotificationEntry] = []

	public init(
		notificationCenter: NotificationCenter = .default,
		historySize: Int = 100
	) {
		self.notificationCenter = notificationCenter
		self.historySize = historySize
		notificationObserver = NotificationObserver(notificationCenter: notificationCenter)
		setUpObserving()
	}

	private func setUpObserving() {
		notificationObserver.when(nil) { [weak self] notification in
			guard let self = self else {
				return
			}
			DispatchQueue.main.async {
				var notificationHistory = self.notificationHistory
				let entry = NotificationEntry(observationDate: Date(), notification: notification)
				notificationHistory.append(entry)
				self.notificationHistory = notificationHistory.suffix(self.historySize)
			}
		}
	}

	public func makeViewController() -> UIViewController {
		return NotificationCenterViewController(instrument: self)
	}
}

struct NotificationEntry: Hashable {

	let observationDate: Date
	let notification: Notification

	func hash(into hasher: inout Hasher) {
		hasher.combine(observationDate)
		hasher.combine(notification.name)
	}
}
