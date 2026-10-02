//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Amir on 01.10.2026.
//

import UIKit

class TrackerCollectionViewCell: UICollectionViewCell{
    static let identifier = "TrackerCollectionViewCell"
    
    private let internalView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let emoji: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .whiteDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dayCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 17
        button.tintColor = .whiteDay
        button.setTitleColor(.whiteDay, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOne), for: .touchUpInside)
        return button
    }()
    
    var onDoneButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        internalView.addSubview(title)
        internalView.addSubview(emoji)
        contentView.addSubview(internalView)
        contentView.addSubview(dayCount)
        contentView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            internalView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            internalView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            internalView.topAnchor.constraint(equalTo: contentView.topAnchor),
            internalView.heightAnchor.constraint(equalToConstant: 90),
            emoji.leadingAnchor.constraint(equalTo: internalView.leadingAnchor, constant: 12),
            emoji.topAnchor.constraint(equalTo: internalView.topAnchor, constant: 12),
            emoji.heightAnchor.constraint(equalToConstant: 24),
            emoji.widthAnchor.constraint(equalTo: emoji.heightAnchor),
            title.leadingAnchor.constraint(equalTo: internalView.leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: internalView.trailingAnchor, constant: -12),
            title.bottomAnchor.constraint(equalTo: internalView.bottomAnchor, constant: -12),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            doneButton.topAnchor.constraint(equalTo: internalView.bottomAnchor, constant: 8),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.widthAnchor.constraint(equalTo: doneButton.heightAnchor),
            dayCount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayCount.topAnchor.constraint(equalTo: internalView.bottomAnchor, constant: 16),
            dayCount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func didTapOne(){
        onDoneButtonTapped?()
    }
    
    func configure(title: String, color: UIColor, emoji: String, days: String, isCompleted: Bool){
        self.title.text = title
        self.internalView.backgroundColor = color
        self.emoji.text = emoji
        self.dayCount.text = "\(days) дней"
        
        let imageName = isCompleted ? "checkmark" : "plus"
        doneButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
