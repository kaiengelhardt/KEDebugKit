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
import KEFoundation
import Combine

class NotificationCenterViewController: ContainerViewController {

	private let instrument: NotificationCenterInstrument

	private let tableViewController = UITableViewController()
	private var tableView: UITableView {
		tableViewController.tableView
	}

	private var dataSource: UITableViewDiffableDataSource<Int, NotificationEntry>?

	private var cancellables = Set<AnyCancellable>()

	init(instrument: NotificationCenterInstrument) {
		self.instrument = instrument
		super.init(nibName: nil, bundle: nil)
		setUpUI()
		setUpObserving()
	}

	private func setUpUI() {
		title = instrument.title
		embeddedViewController = tableViewController

		dataSource = UITableViewDiffableDataSource(
			tableView: tableView
		) { [weak self] tableView, indexPath, itemIdentifier in
			guard let self = self else {
				return nil
			}
			let entry = self.instrument.notificationHistory[indexPath.row]
			// swiftlint:disable:next force_cast
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationCell
			cell.configure(with: entry)
			return cell
		}

		tableView.dataSource = dataSource
		tableView.register(NotificationCell.self, forCellReuseIdentifier: "Cell")
	}

	private func setUpObserving() {
		instrument.$notificationHistory.sink { [weak self] entries in
			guard let self = self else {
				return
			}
			var snapshot = NSDiffableDataSourceSnapshot<Int, NotificationEntry>()
			snapshot.appendSections([0])
			snapshot.appendItems(entries.reversed())
			self.dataSource?.apply(snapshot)
		}
		.store(in: &cancellables)
	}
}
