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
        
        addViews()
        addConstraints()
        configureViews()
        configureNavigationBar()
        setDismissKeyboard()
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
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(Constants.horizontalMargin)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(Constants.smallVerticalSpacing)
            make.horizontalEdges.equalTo(titleTextView.snp.horizontalEdges)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.horizontalEdges.equalTo(titleTextView.snp.horizontalEdges)
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        titleTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleTextView.isScrollEnabled = false
        titleTextView.sizeToFit()

        dateLabel.font = .systemFont(ofSize: 16)
        
        descriptionTextView.textColor = .label
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.sizeToFit()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = Color.accent
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    private func setDismissKeyboard() {
       let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboardTouchOutside))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
}

private enum Constants {
    static let smallVerticalSpacing: CGFloat = 8
    static let verticalSpacing: CGFloat = 16
    
    static let horizontalMargin: CGFloat = 20
}
