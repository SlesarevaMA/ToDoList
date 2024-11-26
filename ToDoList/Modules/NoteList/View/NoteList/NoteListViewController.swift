//
//  NoteListViewController.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 19.11.2024.
//

import UIKit
import SnapKit


protocol NoteListViewInput: AnyObject {
    func addNotes(models: [NoteListViewModel])
}

final class NoteListViewController: UIViewController, NoteListViewInput {
    private let output: NoteListViewOutput
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)

    private let centerBarButtonItem = UIBarButtonItem(
        title: nil,
        style: .plain,
        target: nil,
        action: nil
    )
    
    private var noteListModels = [NoteListViewModel]()
    private var filteredData = [NoteListViewModel]()
    
    init(noteListViewOutput: NoteListViewOutput) {
        self.output = noteListViewOutput
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        output.viewIsAppearing()
    }
    
    func addNotes(models: [NoteListViewModel]) {
        noteListModels = models
        centerBarButtonItem.title = "\(models.count) задач"
        tableView.reloadData()
    }

    private func setup() {
        addViews()
        addConstraints()
        configureViews()
        congigureToolBar()
        setupTableView()
        confifureSearchController()
    }
    
    private func addViews() {
        [tableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func addConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: NoteListTableViewCell.self)
        tableView.backgroundColor = .systemBackground
    }
    
    private func configureViews() {
        navigationItem.title = "Задачи"
        navigationItem.backButtonTitle = "Назад"

        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    
    private func congigureToolBar() {
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonItemTapped)
        )
        
        navigationController?.toolbar.backgroundColor = .systemGray6
        navigationController?.toolbar.tintColor = Color.accent
        navigationController?.setToolbarHidden(false, animated: false)
        setToolbarItems([.flexibleSpace(), centerBarButtonItem,.flexibleSpace(), rightBarButtonItem], animated: false)
    }
    
    private func confifureSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    @objc private func rightBarButtonItemTapped() {
        output.rightBarButtonItemTapped()
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

extension NoteListViewController: NoteListTableViewCellDelegate {
    func completeChanged(id: UUID, completed: Bool) {
        output.completeChanged(id: id, completed: completed)
    }
}

extension NoteListViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        filteredData = noteListModels.filter({ note in
            note.title.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredData.count : noteListModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteListTableViewCell = tableView.dequeReusableCell(for: indexPath)
        let note = isFiltering() ? filteredData[indexPath.row] : noteListModels[indexPath.row]
        cell.configure(with: note)
        cell.delegate = self
        
        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = noteListModels[indexPath.row]
        output.didTapCell(id: model.id)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            // Создание действий для меню
            let firstAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { _ in
                let model = self.noteListModels[indexPath.row]
                self.output.firstActionTapped(id: model.id)
            }
            
            let secondAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                print("Поделиться")
            }
            
            let thirdAction = UIAction(
                title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive
            ) { _ in
                let model = self.noteListModels[indexPath.row]
                self.noteListModels.removeAll { note in
                    note.id == model.id
                }
                
                self.centerBarButtonItem.title = "\(self.noteListModels.count) задач"
                tableView.reloadData()
                self.output.thirdActionTapped(id: model.id)
            }
            
            return UIMenu(children: [firstAction, secondAction, thirdAction])
        }
        
        return configuration
    }
}

private enum Constants {
    static let smallVerticalSpacing: CGFloat = 10
    static let verticalSpacing: CGFloat = 16
    
    static let horizontalMargin: CGFloat = 20
}
