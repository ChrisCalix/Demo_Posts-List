//
//  SceneDelegate.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene),
              let view = PostsListViewController.instantiate(from: Constants.Views.home.rawValue)
        else { return }
        
        let navigationController = UINavigationController(rootViewController: view)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

