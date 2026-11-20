//
//  FilterViewController.swift
//  Tracker
//
//  Created by Amir on 18.11.2026.
//
import UIKit
import Foundation

enum TaskFilter: String, CaseIterable{
    case all = "Все трекеры"
    case current = "Трекеры на сегодня"
    case completed = "Завершенные"
    case uncompleted = "Не завершенные"
}

final class FilterViewController: UIViewController{
    var selectedFilter = TaskFilter.all
    var onFilterSelected: ((TaskFilter) -> Void)?
    
    lazy var filterTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.separatorColor = .customGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(filterTableView)
        
        NSLayoutConstraint.activate([
            filterTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }
}


extension FilterViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskFilter.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
        let filter = TaskFilter.allCases[indexPath.row]
        var checkMark = filter == selectedFilter ? true : false
        cell.configure(with: filter.rawValue, checkMark: checkMark)
        return cell
    }
}

extension FilterViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onFilterSelected?(TaskFilter.allCases[indexPath.row])
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
