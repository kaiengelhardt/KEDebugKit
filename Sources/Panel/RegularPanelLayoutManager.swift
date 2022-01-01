//
//  Created by Kai Engelhardt on 27.12.21
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

import Foundation
import KEFoundation
import UIKit

class RegularPanelLayoutManager {

	var frame: Frame {
		didSet {
			updateConstraints()
		}
	}

	private let layoutSurface: LayoutSurface
	private let containingLayoutSurface: LayoutSurface

	@ActiveConstraint private var constraints: [NSLayoutConstraint] = []

	init(
		frame: Frame = Frame(size: .regular, horizontalPosition: .leading, verticalPosition: .top),
		layoutSurface: LayoutSurface,
		containingLayoutSurface: LayoutSurface
	) {
		self.frame = frame
		self.layoutSurface = layoutSurface
		self.containingLayoutSurface = containingLayoutSurface
	}

	static func constraints(
		forPositioningLayoutSurface layoutSurface: LayoutSurface,
		withFrame frame: Frame,
		inLayoutSurface containingLayoutSurface: LayoutSurface
	) -> [NSLayoutConstraint] {
		var constraints: [NSLayoutConstraint] = []

		switch frame.horizontalPosition {
		case .leading:
			constraints += [
				layoutSurface.leadingAnchor.constraint(equalTo: containingLayoutSurface.leadingAnchor),
			]
		case .trailing:
			constraints += [
				layoutSurface.trailingAnchor.constraint(equalTo: containingLayoutSurface.trailingAnchor),
			]
		}

		if frame.size == .regular {
			constraints += [
				layoutSurface.heightAnchor.constraint(
					equalTo: containingLayoutSurface.heightAnchor,
					multiplier: 0.5
				)
					.with(priority: .defaultHigh),
				layoutSurface.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),
			]
			switch frame.verticalPosition {
			case .top:
				constraints += [
					layoutSurface.topAnchor.constraint(equalTo: containingLayoutSurface.topAnchor),
				]
			case .bottom:
				constraints += [
					layoutSurface.bottomAnchor.constraint(equalTo: containingLayoutSurface.bottomAnchor),
				]
			}
		}

		if frame.size == .regular || frame.size == .large {
			constraints += [
				layoutSurface.widthAnchor.constraint(equalToConstant: 320),
			]
		}

		if frame.size == .large || frame.size == .extraLarge {
			constraints += [
				layoutSurface.topAnchor.constraint(equalTo: containingLayoutSurface.topAnchor),
				layoutSurface.bottomAnchor.constraint(equalTo: containingLayoutSurface.bottomAnchor),
			]
		}

		if frame.size == .extraLarge {
			constraints += [
				layoutSurface.widthAnchor.constraint(equalTo: containingLayoutSurface.widthAnchor, multiplier: 0.5),
			]
		}
		return constraints
	}

	private func updateConstraints() {
		constraints = Self.constraints(
			forPositioningLayoutSurface: layoutSurface,
			withFrame: frame,
			inLayoutSurface: containingLayoutSurface
		)
	}
}

extension RegularPanelLayoutManager {

	struct Frame: Hashable {

		var size: Size
		var horizontalPosition: HorizontalPosition
		var verticalPosition: VerticalPosition
	}
}

extension RegularPanelLayoutManager.Frame {

	enum HorizontalPosition: Hashable {

		case leading
		case trailing
	}

	enum VerticalPosition: Hashable {

		case top
		case bottom
	}

	enum Size: Hashable {

		case regular
		case large
		case extraLarge
	}
}
