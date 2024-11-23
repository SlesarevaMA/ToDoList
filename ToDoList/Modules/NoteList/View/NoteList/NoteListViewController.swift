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
    private let centerBarButtonItem = UIBarButtonItem(
        title: nil,
        style: .plain,
        target: nil,
        action: nil
    )
    
    private var noteListModels = [NoteListViewModel]()
    
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
        
        output.viewWillAppear()
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
    
    @objc private func rightBarButtonItemTapped() {
        output.rightBarButtonItemTapped()
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteListModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteListTableViewCell = tableView.dequeReusableCell(for: indexPath)
        let model = noteListModels[indexPath.row]
                
        cell.configure(with: model)
        
        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = noteListModels[indexPath.row]
        output.didTapCell(id: model.id)
    }
}

private enum Constants {
    static let smallVerticalSpacing: CGFloat = 10
    static let verticalSpacing: CGFloat = 16
    
    static let horizontalMargin: CGFloat = 20
}
