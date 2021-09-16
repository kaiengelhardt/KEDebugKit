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

class UserDefaultsInstrumentViewController: ContainerViewController {

	private let instrument: UserDefaultsInstrument

	private let tabController = UITabBarController()

	private let userDefaultsBrowserNavigationController = UINavigationController()
	private let userDefaultsBrowserViewController: UserDefaultsBrowserViewController
	private let userDefaultsChangesNavigationController = UINavigationController()
	private let userDefaultsChangesViewController: UserDefaultsChangesViewController

	init(instrument: UserDefaultsInstrument) {
		self.instrument = instrument
		userDefaultsBrowserViewController = UserDefaultsBrowserViewController(instrument: instrument)
		userDefaultsChangesViewController = UserDefaultsChangesViewController(instrument: instrument)
		super.init(nibName: nil, bundle: nil)
		setUpUI()
	}

	private func setUpUI() {
		title = instrument.title
		embeddedViewController = tabController
		view.backgroundColor = .systemBackground

		tabController.viewControllers = [
			userDefaultsBrowserNavigationController,
			userDefaultsChangesNavigationController,
		]

		userDefaultsBrowserNavigationController.viewControllers = [
			userDefaultsBrowserViewController,
		]
		userDefaultsChangesNavigationController.viewControllers = [
			userDefaultsChangesViewController,
		]

		setOverrideTraitCollection(UITraitCollection(traitsFrom: [
			UITraitCollection(horizontalSizeClass: .compact),
			UITraitCollection(verticalSizeClass: .compact),
		]), forChild: tabController)
	}
}
