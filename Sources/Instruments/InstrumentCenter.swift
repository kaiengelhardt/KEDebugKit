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

import Foundation
import KEFoundation

public class InstrumentCenter {

	public static let `default` = InstrumentCenter()

	@Observable public private(set) var instruments: [Instrument] = []

	private var lastSelectedInstrument: Instrument?
	let noInstrument = NoInstrument()

	public init() {}

	var defaultInstrument: Instrument {
		if lastSelectedInstrument is NoInstrument {
			return instruments.first ?? noInstrument
		} else {
			return lastSelectedInstrument ?? instruments.first ?? noInstrument
		}
	}

	public func addInstrument(_ addedInstrument: Instrument) {
		instruments.append(addedInstrument)
	}

	public func removeInstrument(_ removedInstrument: Instrument) {
		if lastSelectedInstrument === removedInstrument {
			lastSelectedInstrument = nil
		}
		instruments.removeAll(where: {
			removedInstrument === $0
		})
	}

	func setLastSelectedInstrument(_ instrument: Instrument) {
		lastSelectedInstrument = instrument
	}
}
