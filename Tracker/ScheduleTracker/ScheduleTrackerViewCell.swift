//
//  ScheduleTrackerViewCell.swift
//  Tracker
//
//  Created by Amir on 30.09.2026.
//
import UIKit

class ScheduleTrackerViewCell: UITableViewCell{
    static var identifier = "ScheduleTrackerViewCell"
    
    var onSwitchChanged: ((Bool) -> Void)?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scheduleSwitch: UISwitch = {
        let customSwitch = UISwitch()
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        customSwitch.onTintColor = .customBlue
        return customSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        backgroundColor = .clear
        contentView.backgroundColor = .backgroundDay
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(scheduleSwitch)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            scheduleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scheduleSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
        
        scheduleSwitch.addTarget(self, action: #selector(switched), for: .valueChanged)
    }
    
    @objc private func switched(){
        onSwitchChanged?(scheduleSwitch.isOn)
    }
    
    func configure(with title: String, isOn: Bool){
        titleLabel.text = title
        scheduleSwitch.isOn = isOn
    }
}
