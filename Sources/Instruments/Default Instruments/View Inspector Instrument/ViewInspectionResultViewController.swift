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
import KEFoundation

class ViewInspectionResultViewController: ContainerViewController {

	private let instrument: ViewInspectorInstrument

	private var dataSource: UICollectionViewDiffableDataSource<String, String>?

	private let collectionViewController: UICollectionViewController
	private var collectionView: UICollectionView {
		collectionViewController.collectionView
	}

	private var cancellables = Set<AnyCancellable>()

	init(instrument: ViewInspectorInstrument) {
		let configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
		let layout = UICollectionViewCompositionalLayout.list(using: configuration)
		collectionViewController = UICollectionViewController(collectionViewLayout: layout)
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
		title = instrument.title
		view.backgroundColor = .systemBackground

		embeddedViewController = collectionViewController
		dataSource = UICollectionViewDiffableDataSource(
			collectionView: collectionView
		) { [weak self] collectionView, indexPath, itemIdentifier in
			guard let self = self else {
				return nil
			}
			return self.dequeueCell(using: collectionView, at: indexPath, for: itemIdentifier)
		}
		collectionView.dataSource = dataSource

		let inspectButton = UIBarButtonItem(
			image: UIImage(systemName: "scope"),
			style: .plain,
			target: self,
			action: #selector(inspect)
		)
		navigationItem.rightBarButtonItem = inspectButton
	}

	private func setUpObserving() {
		instrument.viewInspectionResults.sink { completion in
		} receiveValue: { [weak self] results in
			guard let self = self else {
				return
			}
			print(self)
			print(results)
		}
		.store(in: &cancellables)
	}

	@objc
	private func inspect() {
		instrument.beginInspecting()
	}

	private func dequeueCell(
		using collectionView: UICollectionView,
		at indexPath: IndexPath,
		for item: String
	) -> UICollectionViewCell? {
		return nil
	}
}
