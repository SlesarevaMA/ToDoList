//
//  NoteListTableViewCell.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 20.11.2024.
//

import UIKit
import SnapKit


protocol NoteListTableViewCellDelegate: AnyObject {
    func completeChanged(id: UUID, completed: Bool)
}

final class NoteListTableViewCell: UITableViewCell {
    weak var delegate: NoteListTableViewCellDelegate?
    
    private let checkmarkButton = UIButton()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()

    private var id: UUID?
    private var completed: Bool?
    private var titleString: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.attributedText = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }
    
    func configure(with model: NoteListViewModel) {
        titleString = model.title
        descriptionLabel.text = model.description
        dateLabel.text = model.dateString

        configureCheckmarkButton(completed: model.completed)

        id = model.id
        completed = model.completed
    }
    
    private func configureCheckmarkButton(completed: Bool) {
        if completed {
            checkmarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            checkmarkButton.tintColor = Color.accent
            
            guard let titleString else {
                return
            }
            
            let attributedString = NSMutableAttributedString(string: titleString)
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: titleString.count)
            )
            
            titleLabel.attributedText = attributedString
            titleLabel.textColor = Color.notActive
            descriptionLabel.textColor = Color.notActive
        } else {
            checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkmarkButton.tintColor = Color.stroke
            
            guard let titleString else {
                return
            }
            
            titleLabel.attributedText = NSMutableAttributedString(string: titleString)
            titleLabel.textColor = .label
            descriptionLabel.textColor = .label
        }
    }

    private func setup() {
        configureViews()
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        [checkmarkButton, titleLabel, descriptionLabel, dateLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    private func addConstraints() {
        checkmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalSpacing)
            make.leading.equalToSuperview().offset(Constants.horizontalMargin)
            make.height.equalTo(checkmarkButton.snp.width)
            make.height.equalTo(Constants.iconHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(checkmarkButton.snp.top)
            make.leading.equalTo(checkmarkButton.snp.trailing).offset(Constants.horizontalSpacing)
            make.trailing.equalToSuperview().inset(Constants.horizontalMargin)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.smallVerticalSpacing)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(Constants.horizontalMargin)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.smallVerticalSpacing)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(Constants.horizontalMargin)
            make.bottom.equalToSuperview().inset(Constants.verticalSpacing)
        }
    }
    
    private func configureViews() {
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        
        dateLabel.textColor = Color.stroke
        dateLabel.font = .systemFont(ofSize: 16)
        
        checkmarkButton.addTarget(self, action: #selector(checkmarkButtonTapped), for: .touchUpInside)
    }

    @objc private func checkmarkButtonTapped() {
        configureCheckmarkButton(completed: !(completed ?? true))
        
        completed?.toggle()
        
        if let completed, let id {
            delegate?.completeChanged(id: id, completed: completed)
        }
    }
}

private enum Constants {
    static let smallVerticalSpacing: CGFloat = 6
    static let verticalSpacing: CGFloat = 12
    
    static let horizontalSpacing: CGFloat = 8
    static let iconHeight: CGFloat = 24
    static let horizontalMargin: CGFloat = 20
}
