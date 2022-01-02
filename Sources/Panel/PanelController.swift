//
//  Created by Kai Engelhardt on 08.08.21.
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

class PanelController: UIViewController {

	private let container = ContainerViewController()
	var embeddedViewController: UIViewController? {
		get {
			container.embeddedViewController
		}
		set {
			container.embeddedViewController = newValue
			if let viewController = newValue {
				observeTitle(of: viewController)
			}
		}
	}
	private var containerView: UIView {
		container.view
	}

	// We need to use `init(frame:)` here, since `init()` produces constraints conflict logs.
	private let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))

	var leadingBarButtonItem: UIBarButtonItem? {
		get {
			if toolbar.items?.first != leadingSpaceItem {
				return toolbar.items?.first
			}
			return nil
		}
		set {
			if toolbar.items?.first != leadingSpaceItem {
				toolbar.items?.removeFirst()
			}
			if let item = newValue {
				toolbar.items?.insert(item, at: 0)
			}
		}
	}

	private let leadingSpaceItem = UIBarButtonItem(systemItem: .flexibleSpace)

	private let titleLabel = UILabel()

	private let trailingSpaceItem = UIBarButtonItem(systemItem: .flexibleSpace)

	var trailingBarButtonItem: UIBarButtonItem? {
		get {
			if toolbar.items?.last != trailingSpaceItem {
				return toolbar.items?.last
			}
			return nil
		}
		set {
			if toolbar.items?.last != trailingSpaceItem {
				toolbar.items?.removeLast()
			}
			if
				let item = newValue,
				let index = toolbar.items?.count
			{
				toolbar.items?.insert(item, at: index)
			}
		}
	}

	private var titleObservation: NSKeyValueObservation?

	init() {
		super.init(nibName: nil, bundle: nil)
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

		view.layer.shadowRadius = 32
		view.layer.shadowOffset = CGSize(width: 0, height: 12)
		view.layer.shadowOpacity = 0.333
		view.layer.shadowColor = UIColor.black.cgColor

		view.addSubview(toolbar)
		constraints += [
			toolbar.topAnchor.constraint(equalTo: view.topAnchor),
			toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			toolbar.heightAnchor.constraint(equalToConstant: 44),
		]
		toolbar.translatesAutoresizingMaskIntoConstraints = false
		toolbar.clipsToBounds = true
		toolbar.layer.cornerRadius = 12
		toolbar.items = [
			leadingSpaceItem,
			UIBarButtonItem(customView: titleLabel),
			trailingSpaceItem,
		]

		titleLabel.textColor = .label
		titleLabel.font = .preferredFont(forTextStyle: .headline)

		addChild(container)
		view.addSubview(containerView)
		container.didMove(toParent: self)
		constraints += [
			containerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 8),
			containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		]
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.clipsToBounds = true
		containerView.layer.cornerRadius = 12
	}

	private func observeTitle(of viewController: UIViewController) {
		titleObservation = viewController.observe(\.title) { [weak self] viewController, _ in
			self?.updateTitleLabel()
		}
		updateTitleLabel()
	}

	private func updateTitleLabel() {
		titleLabel.text = embeddedViewController?.title
	}
}
