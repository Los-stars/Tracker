//
//  NewTaskTrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Amir on 08.10.2026.
//

import UIKit

final class NewTaskTrackerCollectionViewCell: UICollectionViewCell{
    static var identifier = "NewTaskTrackerCollectionViewCell"
    
    private let elementLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.clear.cgColor
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(borderView)
        addSubview(colorView)
        addSubview(elementLabel)
        
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 3),
            colorView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 3),
            colorView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -3),
            colorView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -3),
            elementLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            elementLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func configure(element: String, isSelected: Bool){
        elementLabel.isHidden = false
        elementLabel.text = element
        colorView.isHidden = true
        borderView.isHidden = true
        borderView.layer.borderColor = UIColor.clear.cgColor
        
        elementLabel.text = element
        layer.cornerRadius = 8
        backgroundColor = isSelected ? UIColor.customLightGray : UIColor.clear
    }
    
    func configure(with color: UIColor, isSelected: Bool){
        elementLabel.isHidden = true
        elementLabel.text = nil
        colorView.isHidden = false
        colorView.backgroundColor = color
        if isSelected{
            UIView.animate(withDuration: 0.15){
                self.colorView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            borderView.isHidden = false
            borderView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        }else{
            self.colorView.transform = .identity
            borderView.isHidden = true
            borderView.layer.borderColor = UIColor.clear.cgColor
        }
        
        backgroundColor = .clear
    }
}
