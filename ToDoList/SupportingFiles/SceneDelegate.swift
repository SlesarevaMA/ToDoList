//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var router: Router?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let isRunnningTests = NSClassFromString("XCTestCase") != nil
        
        guard !isRunnningTests else {
            return
        }

        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let assembly = Assembly()
        
        let navigationController = UINavigationController()
        
        router = RouterImpl(navigationController: navigationController, assembly: assembly)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        router?.showNoteList()
    }
}
