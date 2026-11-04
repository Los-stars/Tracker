//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Amir on 05.11.2026.
//

import UIKit

class EditCategoryViewController: UIViewController {
    
    var initialTitle: String?
    var onEdit: ((String) -> Void)?
    
    private lazy var nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.clearButtonMode = .whileEditing
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.whiteDay, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var trimmedText: String {
        (nameTrackerTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTrackerTextField .text = initialTitle
        
        setupUI()
    }
    
    func setupUI(){
        view.backgroundColor = .whiteDay
        view.addSubview(nameTrackerTextField)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            nameTrackerTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        updateButtonState()
    }
    
    func updateButtonState(){
        doneButton.backgroundColor = doneButton.isEnabled ? .blackDay : .customGray
    }
    
    @objc func textFieldDidChange(){
        if !(nameTrackerTextField.text ?? "").isEmpty{
            doneButton.isEnabled = true
        }else{
            doneButton.isEnabled = false
        }
        
        updateButtonState()
    }
    
    @objc func buttonDidTap(){
        onEdit?(trimmedText)
        dismiss(animated: true)
    }
}
