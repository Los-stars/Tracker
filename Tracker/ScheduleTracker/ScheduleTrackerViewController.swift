//
//  ScheduleTrackerViewController.swift
//  Tracker
//
//  Created by Amir on 30.09.2026.
//
import UIKit



final class ScheduleTrackerViewController: UIViewController{
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(ScheduleTrackerViewCell.self, forCellReuseIdentifier: ScheduleTrackerViewCell.identifier)
        return tableView
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
        button.addTarget(self, action: #selector(didTapOne), for: .touchUpInside)
        return button
    }()
    
    var onScheduleSelected: (([WeekDay]) -> Void)?
    
    var selectedDays: Set<WeekDay> = []
    override func viewDidLoad() {
        view.backgroundColor = .white
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(scheduleTableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 540),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func didTapOne(){
        onScheduleSelected?(Array(selectedDays))
        dismiss(animated: true)
    }
}

extension ScheduleTrackerViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTrackerViewCell") as? ScheduleTrackerViewCell else { return UITableViewCell() }
        let day = WeekDay.allCases[indexPath.row]
        cell.configure(with: day.rawValue, isOn: selectedDays.contains(day))
        
        cell.onSwitchChanged = { [weak self] isOn in
            guard let self else { return }
            if isOn{
                self.selectedDays.insert(day)
            }else{
                self.selectedDays.remove(day)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ScheduleTrackerViewController: UITableViewDelegate{
    
}
