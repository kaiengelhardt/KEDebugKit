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

class UserDefaultsChangeCell: UITableViewCell {

	private let changeLabel = UILabel()
	private let keyLabel = UILabel()
	private let previousValueLabel = UILabel()
	private let valueLabel = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setUpUI()
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

		let stackView = UIStackView()
		contentView.addSubview(stackView)
		constraints += stackView.constraintsMatchingEdges(of: contentView.layoutMarginsGuide)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fill
		stackView.spacing = UIStackView.spacingUseSystem

		stackView.addArrangedSubview(changeLabel)
		changeLabel.font = .monospacedSystemFont(ofSize: 20, weight: .bold)
		changeLabel.text = "+"
		changeLabel.textColor = .systemRed

		let labelStackView = UIStackView()
		stackView.addArrangedSubview(labelStackView)
		labelStackView.axis = .vertical
		labelStackView.alignment = .fill
		labelStackView.distribution = .fill
		labelStackView.spacing = 4

		labelStackView.addArrangedSubview(keyLabel)
		keyLabel.numberOfLines = 0
		keyLabel.textColor = .label
		keyLabel.font = .systemFont(ofSize: 15, weight: .bold)

		labelStackView.addArrangedSubview(previousValueLabel)
		previousValueLabel.numberOfLines = 0
		previousValueLabel.textColor = .secondaryLabel
		previousValueLabel.font = .systemFont(ofSize: 15, weight: .regular)

		labelStackView.addArrangedSubview(valueLabel)
		valueLabel.numberOfLines = 0
		valueLabel.textColor = .secondaryLabel
		valueLabel.font = .systemFont(ofSize: 15, weight: .regular)
	}

	func configure(with change: UserDefaultsInstrument.Change) {
		switch change {
		case let .added(key: key, value: value):
			changeLabel.text = "+"
			changeLabel.textColor = .systemGreen
			keyLabel.text = key
			previousValueLabel.isHidden = true
			previousValueLabel.text = ""
			valueLabel.text = string(for: value)
		case let .updated(key: key, previousValue: previousValue, newValue: newValue):
			changeLabel.text = "~"
			changeLabel.textColor = .systemBlue
			keyLabel.text = key
			previousValueLabel.isHidden = false
			previousValueLabel.text = string(for: previousValue)
			valueLabel.text = string(for: newValue)
		case let .deleted(key: key, value: value):
			changeLabel.text = "-"
			changeLabel.textColor = .systemRed
			keyLabel.text = key
			previousValueLabel.isHidden = true
			previousValueLabel.text = ""
			valueLabel.text = string(for: value)
		}
	}

	private func string(for value: Any) -> String? {
		if let value = value as? CustomStringConvertible {
			return value.description
		} else {
			return nil
		}
	}
}
