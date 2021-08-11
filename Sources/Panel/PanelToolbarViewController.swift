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
import KEFoundation

class PanelToolbarViewController: UIViewController {

	private let leadingContainer = ContainerView()

	var leadingView: UIView? {
		get {
			leadingContainer.embeddedView
		}
		set {
			leadingContainer.embeddedView = newValue
		}
	}

	private let trailingContainer = ContainerView()

	var trailingView: UIView? {
		get {
			trailingContainer.embeddedView
		}
		set {
			trailingContainer.embeddedView = newValue
		}
	}

	private let titleLabel = UILabel()

	init() {
		super.init(nibName: nil, bundle: nil)
		setUpUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setUpUI() {
		var constraints: [NSLayoutConstraint] = []
		defer {
			NSLayoutConstraint.activate(constraints)
		}

		view.addSubview(leadingContainer)
		constraints += [
			leadingContainer.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			leadingContainer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
			leadingContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
		]
		leadingContainer.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(titleLabel)
		constraints += [
			titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingContainer.trailingAnchor),
			trailingContainer.leadingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor),
			titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
		]
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.setContentCompressionResistancePriority(500, for: .horizontal)
		titleLabel.textColor = .label
		titleLabel.font = .preferredFont(forTextStyle: .headline)

		view.addSubview(trailingContainer)
		constraints += [
			trailingContainer.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			trailingContainer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
			trailingContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
		]
		trailingContainer.translatesAutoresizingMaskIntoConstraints = false
	}
}
