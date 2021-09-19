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

class ViewInspectionResultViewController: UIViewController {

	private let instrument: ViewInspectorInstrument

	private let addressLabel = UILabel()
	private let accessibilityIDLabel = UILabel()
	private let frameLabel = UILabel()

	private var cancellables = Set<AnyCancellable>()

	init(instrument: ViewInspectorInstrument) {
		self.instrument = instrument
		super.init(nibName: nil, bundle: nil)
		setUpUI()
		setUpObserving()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setUpUI() {
		var constraints: [NSLayoutConstraint] = []
		defer {
			NSLayoutConstraint.activate(constraints)
		}

		title = instrument.title

		let stackView = UIStackView()
		view.addSubview(stackView)
		constraints += stackView.constraintsMatchingCenterOfSuperview()
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fill
		stackView.spacing = UIStackView.spacingUseSystem

		stackView.addArrangedSubview(addressLabel)
		stackView.addArrangedSubview(accessibilityIDLabel)
		stackView.addArrangedSubview(frameLabel)
	}

	private func setUpObserving() {
		instrument.viewInspectionResult.sink { completion in
		} receiveValue: { [weak self] result in
			guard let self = self else {
				return
			}
			if let result = result {
				self.frameLabel.text = result.view.frame.debugDescription
				self.accessibilityIDLabel.text = result.view.accessibilityIdentifier
				self.addressLabel.text = ObjectIdentifier(result.view).debugDescription
			}
		}
		.store(in: &cancellables)
	}
}
