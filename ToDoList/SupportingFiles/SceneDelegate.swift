//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let jsonDecoder = JSONDecoder()
        let networkService: NetworkService = NetworkServiceImpl(jsonDecoder: jsonDecoder)
        let coreDataManager: CoreDataManager = CoreDataManagerImpl()

        let noteListInteractor: NoteListInteractor = NoteListInteractorImpl(
            networkService: networkService,
            coreDataManager: coreDataManager
        )
        
        let noteListPresenter: NoteListViewOutput = NoteListPresenter(interactor: noteListInteractor)
        let noteListViewController = NoteListViewController(noteListViewOutput: noteListPresenter)
        
        noteListPresenter.view = noteListViewController
        
        
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = noteListViewController
        window?.makeKeyAndVisible()
    }
}
