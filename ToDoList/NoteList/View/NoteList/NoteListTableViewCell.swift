//
//  NoteListTableViewCell.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 20.11.2024.
//

import UIKit
import SnapKit


final class NoteListTableViewCell: UITableViewCell {
    private let checkmarkButton = UIButton()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()

    private var id: Int?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }
    
    func configure(with model: NoteListViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        dateLabel.text = model.dateString

        configureCheckmarkButton(completed: model.completed)

        id = model.id
    }
    
    private func configureCheckmarkButton(completed: Bool) {
        if completed {
            checkmarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            checkmarkButton.backgroundColor = Color.accent
        } else {
            checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkmarkButton.backgroundColor = Color.stroke
        }
    }

    private func setup() {
        configureViews()
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        [checkmarkButton, titleLabel, descriptionLabel, dateLabel]
            .forEach { addSubview($0) }
    }
    
    private func addConstraints() {
        checkmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(checkmarkButton.snp.trailing).offset(Constants.horizontalSpacing)
            make.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.smallVerticalSpacing)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.smallVerticalSpacing)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureViews() {
        titleLabel.textColor = .label
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        descriptionLabel.textColor = .label
        descriptionLabel.font = .systemFont(ofSize: 16)
        
        descriptionLabel.textColor = Color.stroke
        descriptionLabel.font = .systemFont(ofSize: 16)
    }
}

private enum Constants {
    static let smallVerticalSpacing: CGFloat = 6
//    static let verticalSpacing: CGFloat = 16
    
    static let horizontalSpacing: CGFloat = 8
}
