//
//  NoteViewController.swift
//  ToDoList
//
//  Created by Margarita Slesareva on 21.11.2024.
//

import UIKit
import SnapKit


protocol NoteViewInput: AnyObject {
    var currentText: String { get }
    var currentDescription: String { get }
    
    func configure(with model: NoteViewModel)
    func setFocusOnTitle()
    func setFocusOnDescription()
}

final class NoteViewController: UIViewController, NoteViewInput {
    
    var currentText: String {
        get {
            return titleTextView.text
        }
    }
    
    var currentDescription: String {
        get {
            return descriptionTextView.text
        }
    }
    
    private let output: NoteViewOutput
    
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
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
        
        output.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        output.viewWillDisappear()
    }
    
    func configure(with model: NoteViewModel) {
        dateLabel.text = model.dateString
        descriptionTextView.text = model.description
        
        let attributedString = NSMutableAttributedString(string: model.title)
        attributedString.addAttribute(
            .font,
            value: UIFont.boldSystemFont(ofSize: 34),
            range: NSRange(location: 0, length: model.title.count)
        )
        
        if model.completed {
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: model.title.count)
            )
            
            titleTextView.attributedText = attributedString
            titleTextView.textColor = Color.notActive
            descriptionTextView.textColor = Color.notActive
        } else {
            titleTextView.attributedText = attributedString
            titleTextView.textColor = .label
            descriptionTextView.textColor = .label
        }
    }
    
    func setFocusOnTitle() {
        titleTextView.becomeFirstResponder()
    }
    
    func setFocusOnDescription() {
        descriptionTextView.becomeFirstResponder()
    }
    
    private func setupUI() {
        addViews()
        configureViews()
        addConstraints()
        configureNavigationBar()
        observeKeyboardChanges()
    }
    
    private func observeKeyboardChanges() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }

        let keyboardHeight = keyboardFrame.cgRectValue.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        [titleTextView, dateLabel, descriptionTextView].forEach {
            scrollContentView.addSubview($0)
        }
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        titleTextView.isScrollEnabled = false
        titleTextView.setContentHuggingPriority(.required, for: .vertical)
        titleTextView.sizeToFit()

        dateLabel.font = .systemFont(ofSize: 16)
        
        descriptionTextView.textColor = .label
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.sizeToFit()
    }
    
    private func addConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.smallVerticalSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalMargin)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(Constants.smallVerticalSpacing)
            make.horizontalEdges.equalTo(titleTextView.snp.horizontalEdges)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.horizontalEdges.equalTo(titleTextView.snp.horizontalEdges)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = Color.accent
        navigationController?.setToolbarHidden(true, animated: false)
    }
}

private enum Constants {
    static let smallVerticalSpacing: CGFloat = 8
    static let verticalSpacing: CGFloat = 16
    
    static let horizontalMargin: CGFloat = 20
}
