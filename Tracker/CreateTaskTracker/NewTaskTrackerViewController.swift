//
//  NewTaskTrackerViewController.swift
//  Tracker
//
//  Created by Amir on 30.09.2026.
//

import UIKit

final class NewTaskTrackerViewController: UIViewController{
    
    private let nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.clearButtonMode = .whileEditing
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let limitLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.isHidden = true
        return label
    }()
    
    private let menuTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(NewTaskTrackerTableViewCell.self, forCellReuseIdentifier: NewTaskTrackerTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.whiteDay, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor.customRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        button.backgroundColor = .clear
        
        button.layer.borderColor = UIColor.customRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            cancelButton,
            createButton
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    var delegate: NewTaskTrackerDelegate?
    private let presenter = NewTaskTrackerViewControllerPresenter()
    var menuTableViewItem = ["Категория","Расписание"]
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        nameTrackerTextField.delegate = self
        setupUI()
        updateCreateButtonState()
    }
    
    func updateCreateButtonState(){
        createButton.backgroundColor = createButton.isEnabled ? .blackDay : .customGray
    }
    
    func setupUI(){
        view.addSubview(nameTrackerTextField)
        view.addSubview(limitLabel)
        view.addSubview(menuTableView)
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            nameTrackerTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            limitLabel.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 8),
            limitLabel.leadingAnchor.constraint(equalTo: nameTrackerTextField.leadingAnchor),
            limitLabel.trailingAnchor.constraint(equalTo: nameTrackerTextField.trailingAnchor),
            menuTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24),
            menuTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuTableView.heightAnchor.constraint(equalToConstant: 180),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func didTapCancelButton(){
        dismiss(animated: true)
    }
    
    @objc private func didTapCreateButton(){
        guard let title = nameTrackerTextField.text else { return }
        guard let schedule = presenter.formatWeekDayToSchedule() else { return }
        let tracker = Tracker(title: title, color: .brown, emoji: "😪", schedule: schedule)
        delegate?.didCreateTracker(tracker: tracker, category: "Домашний уют")
        dismiss(animated: true)
    }
}

extension NewTaskTrackerViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTableViewItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewTaskTrackerTableViewCell") as? NewTaskTrackerTableViewCell else { return UITableViewCell() }
        
        if indexPath.row == 0{
            cell.configure(with: menuTableViewItem[indexPath.row], subtitle: nil)
        }else{
            cell.configure(with: menuTableViewItem[indexPath.row], subtitle: presenter.scheduleSubtitle)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension NewTaskTrackerViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        limitLabel.isHidden = presenter.checkTextRange(to: updatedText)
        return presenter.checkTextRange(to: updatedText)
    }
}

extension NewTaskTrackerViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            print("Tap Category")
        }else{
            let vc = ScheduleTrackerViewController()
            vc.title = "Расписание"
            vc.selectedDays = presenter.setSelectedDays()
            
            vc.onScheduleSelected = { [weak self] days in
                guard let self else { return }
                self.presenter.updateSchedule(days)
                self.menuTableView.reloadData()
                
                if presenter.selectedDaysNotEmpty(){
                    self.createButton.isEnabled = true
                }
                updateCreateButtonState()
            }
            let navVC = UINavigationController(rootViewController: vc)
            if let sheet = navVC.sheetPresentationController{
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
            }
            present(navVC, animated: true)
        }
    }
}
