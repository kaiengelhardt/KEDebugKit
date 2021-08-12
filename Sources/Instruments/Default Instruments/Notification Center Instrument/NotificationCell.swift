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

import UIKit

class NotificationCell: UITableViewCell {

	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .none
		formatter.timeStyle = .medium
		return formatter
	}()

	private let stackView = UIStackView()
	private let dateLabel = UILabel()
	private let nameLabel = UILabel()

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

		contentView.addSubview(stackView)
		constraints += stackView.constraintsMatchingEdges(of: contentView.layoutMarginsGuide)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fill
		stackView.spacing = UIStackView.spacingUseSystem

		stackView.addArrangedSubview(dateLabel)
		dateLabel.textAlignment = .right
		dateLabel.font = .systemFont(ofSize: 14, weight: .medium)
		dateLabel.textColor = .secondaryLabel

		stackView.addArrangedSubview(nameLabel)
		nameLabel.textAlignment = .left
		nameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
		nameLabel.textColor = .label
		nameLabel.numberOfLines = 0

		accessoryType = .disclosureIndicator
	}

	func configure(with notificationEntry: NotificationEntry) {
		dateLabel.text = Self.dateFormatter.string(from: notificationEntry.observationDate)
		nameLabel.text = notificationEntry.notification.name.rawValue
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		nameLabel.preferredMaxLayoutWidth = stackView.bounds.width
		dateLabel.preferredMaxLayoutWidth = stackView.bounds.width
	}
}
