//
//  SceneDelegate.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 05/12/24.
//

// To do view navigation (by using a stack of view controllers put into a controller for navigation)

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let rootViewController = ContentView()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        print("Scene setup completed.")
    }
}
