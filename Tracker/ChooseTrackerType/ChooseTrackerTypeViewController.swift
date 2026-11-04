//
//  ChooseTrackerTypeViewController.swift
//  Tracker
//
//  Created by Amir on 05.10.2026.
//

import UIKit

class ChooseTrackerTypeViewController: UIViewController {
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.whiteDay, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(switchToNewTaskTrackerViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularHabitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.setTitleColor(.whiteDay, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(switchToNewTaskIrregularTrackerViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            habitButton,
            irregularHabitButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    weak var delegate: NewTaskTrackerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            irregularHabitButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor)
        ])
    }
    
    @objc func switchToNewTaskTrackerViewController(){
        let vc = NewTaskTrackerViewController()
        vc.title = "Новая привычка"
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        if let sheet = navVC.sheetPresentationController{
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(navVC, animated: true)
    }
    
    @objc func switchToNewTaskIrregularTrackerViewController(){
        let vc = NewTaskIrregularTrackerViewController()
        vc.title = "Новое нерегулярное событие"
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        if let sheet = navVC.sheetPresentationController{
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(navVC, animated: true)
    }
}


extension ChooseTrackerTypeViewController: NewTaskTrackerDelegate{
    func didCreateTracker(tracker: Tracker, category: String) {
        delegate?.didCreateTracker(tracker: tracker, category: category)
    }
}
