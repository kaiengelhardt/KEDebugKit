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

import UIKit
import KEFoundation
import Combine

public class InstrumentWindowController: OverlayWindowController {

	private let panelContainer = PanelController()
	private var panelContainerView: UIView {
		panelContainer.view
	}

	private let switcherButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"))
	private let optionsButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"))

	private let instrumentSession: InstrumentSession

	private var cancellables = Set<AnyCancellable>()

	public init(instrumentSession: InstrumentSession) {
		self.instrumentSession = instrumentSession
		super.init(windowSceneWrapper: instrumentSession.windowSceneWrapper)

		setUpUI()
		setUpObserving()
	}

	private func setUpUI() {
		contentViewController.addChild(panelContainer)
		contentView.addSubview(panelContainerView)
		panelContainer.didMove(toParent: contentViewController)
		panelContainerView.frame = CGRect(x: 40, y: 40, width: 320, height: 500)

		panelContainer.trailingBarButtonItem = optionsButton

		updateSwitcherButton(instruments: [])

		window.tag = 696_969
	}

	private func setUpObserving() {
		instrumentSession.$currentlyShownInstrument.sink { [weak self] instrument in
			guard let self = self else {
				return
			}
			self.panelContainer.embeddedViewController = self.instrumentSession.viewController(for: instrument)
		}
		.store(in: &cancellables)

		instrumentSession.instrumentCenter.$instruments.sink { [weak self] instruments in
			self?.updateSwitcherButton(instruments: instruments)
		}
		.store(in: &cancellables)
	}

	private func updateSwitcherButton(instruments: [Instrument]) {
		if instruments.isEmpty {
			panelContainer.leadingBarButtonItem = nil
		} else {
			panelContainer.leadingBarButtonItem = switcherButton

			let switcherActions = instruments.map { instrument in
				UIAction(title: instrument.title) { [weak self] _ in
					guard let self = self else {
						return
					}
					self.instrumentSession.currentlyShownInstrument = instrument
				}
			}
			switcherButton.menu = UIMenu(children: switcherActions)
		}
	}
}
