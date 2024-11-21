//
//  NoteViewController.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 21.11.2024.
//

import UIKit
import SnapKit


final class NoteViewController: UIViewController {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        addConstraints()
        configureViews()
        configureNavigationBar()
    }
    
    func configure(with model: NoteViewModel) {
        titleLabel.text = model.title
        dateLabel.text = model.dateString
        descriptionLabel.text = model.description
    }
    
    private func addViews() {
        [titleLabel, dateLabel, descriptionLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func addConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.smallVerticalSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalMargin)
            make.height.greaterThanOrEqualTo(50)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.smallVerticalSpacing)
            make.horizontalEdges.equalTo(titleLabel.snp.horizontalEdges)
            make.height.greaterThanOrEqualTo(50)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.horizontalEdges.equalTo(titleLabel.snp.horizontalEdges)
        }
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        titleLabel.textColor = .label
        titleLabel.font = .boldSystemFont(ofSize: 34)
        titleLabel.numberOfLines = 0
        
        dateLabel.textColor = Color.stroke
        dateLabel.font = .systemFont(ofSize: 16)
        
        descriptionLabel.textColor = .label
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 0
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
