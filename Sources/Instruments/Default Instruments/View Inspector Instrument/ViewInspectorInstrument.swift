//
//  Created by Kai Engelhardt on 16.09.21
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

public class ViewInspectorInstrument: Instrument {

	public let title = "View Inspector"

	private let subject: PassthroughSubject<UIView?, Never>

	let viewInspectionResult = CurrentValueSubject<ViewInspectionResult?, Never>(nil)

	private var cancellables = Set<AnyCancellable>()

	public init(subject: PassthroughSubject<UIView?, Never>) {
		self.subject = subject
		setUpObserving()
	}

	public func makeViewController() -> UIViewController {
		return ViewInspectionResultViewController(instrument: self)
	}

	private func setUpObserving() {
		subject.map { view in
			guard let view = view else {
				return nil
			}
			return ViewInspectionResult(view: view)
		}
		.subscribe(viewInspectionResult)
		.store(in: &cancellables)
	}
}
