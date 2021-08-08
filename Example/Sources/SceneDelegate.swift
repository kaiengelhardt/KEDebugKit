//
//  SceneDelegate.swift
//  Example
//
//  Created by Kai Engelhardt on 08.08.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let rootViewController = ViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: scene)
        self.window = window
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
