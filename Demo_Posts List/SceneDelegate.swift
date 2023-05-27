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
        view.viewModelBuilder = {
            return PostsListViewModel(input: $0, dependencies: (title: "Posts List", ()))
        }
        
        let navigationController = UINavigationController(rootViewController: view)
        let navigationBar = navigationController.navigationBar
        let appearance = UINavigationBarAppearance()
        let window = UIWindow(windowScene: windowScene)
        
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor.tertiarySystemBackground
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.label,
            
        ]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        
        window.rootViewController = navigationController
        
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

