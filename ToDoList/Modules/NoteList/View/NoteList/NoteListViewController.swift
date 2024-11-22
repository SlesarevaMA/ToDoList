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
    
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    
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
        
        tableView.reloadData()
    }
    
    private func setup() {
        addViews()
        addConstraints()
        configureViews()
        setupTableView()
    }
    
    private func addViews() {
        [titleLabel, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func addConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(Constants.verticalSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalMargin)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom) // equalToSuperview()
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
//        navigationItem.title = "Avatar"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonItemTapped)
        )
        
        let string = "\(noteListModels.count) задач"
        
        let centerBarButtonItem = UIBarButtonItem(
            title: string,
            style: .plain,
            target: nil,
            action: nil
        )
                
        toolbarItems = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(systemItem: .flexibleSpace),
            centerBarButtonItem,
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(systemItem: .flexibleSpace),
            rightBarButtonItem,
            UIBarButtonItem(systemItem: .flexibleSpace),
        ]

        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.toolbar.backgroundColor = .systemGray6
        
        view.backgroundColor = .systemGray6
        
        titleLabel.textColor = .label
        titleLabel.font = .boldSystemFont(ofSize: 34)
        titleLabel.text = "Задачи"
    }
    
    @objc func rightBarButtonItemTapped() {
        
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
        output.cellDidTap(model: model)
    }
}

private enum Constants {
    static let smallVerticalSpacing: CGFloat = 10
    static let verticalSpacing: CGFloat = 16
    
    static let horizontalMargin: CGFloat = 20
}
