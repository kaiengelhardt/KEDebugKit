//
//  Created by Kai Engelhardt on 11.08.21
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
import Combine
import KEFoundation

public class InstrumentSession: Hashable {

	@Observable var currentlyShownInstrument: Instrument {
		didSet {
			guard currentlyShownInstrument !== oldValue else {
				return
			}
			oldValue.didResignActive(in: self)
			instrumentCenter.setLastSelectedInstrument(currentlyShownInstrument)
			currentlyShownInstrument.didBecomeActive(in: self)
		}
	}

	public let instrumentCenter: InstrumentCenter

	private var viewControllerForInstrument: [ObjectIdentifier: UIViewController] = [:]

	let windowSceneWrapper: WindowSceneWrapperProtocol

	private var cancellables = Set<AnyCancellable>()

	public convenience init(windowScene: UIWindowScene, instrumentCenter: InstrumentCenter = .default) {
		self.init(
			windowSceneWrapper: WindowSceneWrapper(windowScene: windowScene),
			instrumentCenter: instrumentCenter
		)
	}

	init(windowSceneWrapper: WindowSceneWrapperProtocol, instrumentCenter: InstrumentCenter) {
		self.windowSceneWrapper = windowSceneWrapper
		self.instrumentCenter = instrumentCenter
		currentlyShownInstrument = instrumentCenter.defaultInstrument
		setUpObserving()
	}

	private func setUpObserving() {
		instrumentCenter.$instruments
			.withPrevious([])
			.sink { [weak self] oldInstruments, newInstruments in
				guard let self = self else {
					return
				}
				if
					self.currentlyShownInstrument is NoInstrument,
					let firstInstrument = newInstruments.first
				{
					self.currentlyShownInstrument = firstInstrument
				}
				self.purgeUnneededViewControllers(forNewInstruments: newInstruments)
				let removedInstruments = self.removedInstruments(
					betweenPreviousInstruments: oldInstruments,
					andNewInstruemnts: newInstruments
				)
				let currentlyShownInstrumentWasRemoved = removedInstruments.contains(where: { instrument in
					instrument === self.currentlyShownInstrument
				})
				if currentlyShownInstrumentWasRemoved {
					self.currentlyShownInstrument = self.instrumentCenter.defaultInstrument
				}
			}
			.store(in: &cancellables)
	}

	func viewController(for instrument: Instrument) -> UIViewController? {
		let instrumentIsInInstrumentCenter = instrumentCenter.instruments.contains(where: { otherInstrument in
			instrument === otherInstrument
		})
		guard instrumentIsInInstrumentCenter else {
			return nil
		}

		let identifier = ObjectIdentifier(instrument)
		let viewController = viewControllerForInstrument[identifier]
		if let viewController = viewController {
			return viewController
		} else {
			let viewController = instrument.makeViewController()
			viewControllerForInstrument[identifier] = viewController
			return viewController
		}
	}

	public func hash(into hasher: inout Hasher) {
		let objectID = ObjectIdentifier(self)
		hasher.combine(objectID)
	}

	public static func == (lhs: InstrumentSession, rhs: InstrumentSession) -> Bool {
		return lhs === rhs
	}

	private func removedInstruments(
		betweenPreviousInstruments previousInstruments: [Instrument],
		andNewInstruemnts newInstruments: [Instrument]
	) -> [Instrument] {
		return previousInstruments.filter { previousInstrument in
			return !newInstruments.contains { newInstrument in
				return previousInstrument === newInstrument
			}
		}
	}

	private func purgeUnneededViewControllers(forNewInstruments instruments: [Instrument]) {
		let instrumentIdentifiers = instruments.map {
			ObjectIdentifier($0)
		}
		for instrumentIdentifier in viewControllerForInstrument.keys {
			if !instrumentIdentifiers.contains(instrumentIdentifier) {
				viewControllerForInstrument[instrumentIdentifier] = nil
			}
		}
	}
}
