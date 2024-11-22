//
//  NoteViewController.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 21.11.2024.
//

import UIKit
import SnapKit

protocol NoteViewInput: AnyObject {
    
    
}


final class NoteViewController: UIViewController {
    private let output: NoteViewOutput
    
    private var modelId: Int?
    
    private let scrollView = UIScrollView()
    private let titleTextView = UITextView()
    private let dateLabel = UILabel()
    private let descriptionTextView = UITextView()
        
    init(output: NoteViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        addConstraints()
        configureViews()
        configureNavigationBar()
        
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let modelId {
            output.viewDidDisappear(id: modelId, title: titleTextView.text, description: descriptionTextView.text)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let modelId {
            output.viewDidDisappear(id: modelId, title: titleTextView.text, description: descriptionTextView.text)
        }
    }
    
    func configure(with model: NoteViewModel) {
        titleTextView.text = model.title
        dateLabel.text = model.dateString
        descriptionTextView.text = model.description
                
        modelId = model.id
    }
    
    private func addViews() {
        [titleTextView, dateLabel, descriptionTextView].forEach {
            scrollView.addSubview($0)
        }
        
        view.addSubview(scrollView)
    }
    
    private func addConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.smallVerticalSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalMargin)
            make.height.greaterThanOrEqualTo(50)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(Constants.smallVerticalSpacing)
            make.horizontalEdges.equalTo(titleTextView.snp.horizontalEdges)
//            make.height.greaterThanOrEqualTo(50)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Constants.verticalSpacing)
//            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalMargin)
            make.horizontalEdges.equalTo(titleTextView.snp.horizontalEdges)
//            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
//        navigationItem.backButtonDisplayMode = .minimal
        
        titleTextView.textColor = .label
        titleTextView.font = .boldSystemFont(ofSize: 34)
        titleTextView.setContentHuggingPriority(.defaultLow, for: .vertical)

//        titleTextField.
        
        dateLabel.textColor = Color.stroke
        dateLabel.font = .systemFont(ofSize: 16)
        
        descriptionTextView.textColor = .label
        descriptionTextView.font = .systemFont(ofSize: 12)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = Color.accent
    }
}

private enum Constants {
    static let smallVerticalSpacing: CGFloat = 8
    static let verticalSpacing: CGFloat = 16
    
    static let horizontalMargin: CGFloat = 20
}
