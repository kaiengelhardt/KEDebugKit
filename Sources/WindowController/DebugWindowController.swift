//
//  DebugWindowController.swift
//  KEDebugKit
//
//  Created by Kai Engelhardt on 08.08.21.
//

import UIKit
import KEFoundation

public class DebugWindowController: UIResponder {

	private let scene: UIWindowScene
	private let window: PassthroughWindow
	private let contentViewController = UIViewController()

	init(windowScene: UIWindowScene) {
		scene = windowScene
		window = PassthroughWindow(windowScene: windowScene)
		super.init()
		setUpUI()
	}

	private func setUpUI() {
		window.bounds = scene.screen.bounds
		window.setFrameToBeNotEntirelyFullscreenToPreventThisWindowFromSwallowingStatusBarEvents()
		window.rootViewController = contentViewController
		window.makeKeyAndVisible()
	}
}
