//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Amir on 24.09.2026.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    var addTrackerIcon = UIButton()
    var trackerTextLabel = UILabel()
    var trackerDate = UIDatePicker()
    var searchTextField = UISearchBar()
    private let presenter = TrackerViewControllerPresenter()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCollectionViewCell")
        return cv
    }()
    
    private let placeholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholderStar"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackDay
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            layout.estimatedItemSize = .zero
        }
        
        setupUIElements()
        setupPlaceolder()
        
        presenter.onDataChanged = { [weak self] in
            self?.collectionView.reloadData()
            self?.updatePlaceholderVisibility()
        }
        
        presenter.setInitialData()
    }
    func updatePlaceholderVisibility(){
        placeholderView.isHidden = presenter.hasVisibleTrackers()
    }
    
    func setupUIElements(){
        guard let addTrackerIconImage = UIImage(named: "addTrackerButtonImage") else { return }
        addTrackerIcon = UIButton.systemButton(
            with: addTrackerIconImage,
            target: self,
            action: nil)
        addTrackerIcon.tintColor = .blackDay
        addTrackerIcon.translatesAutoresizingMaskIntoConstraints = false
        
        trackerTextLabel.text = "Трекеры"
        trackerTextLabel.font = .systemFont(ofSize: 34, weight: .bold)
        trackerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerTextLabel.tintColor = .blackDay
        
        trackerDate.datePickerMode = .date
        trackerDate.preferredDatePickerStyle = .compact
        trackerDate.translatesAutoresizingMaskIntoConstraints = false
        trackerDate.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        searchTextField.placeholder = "Поиск"
        searchTextField.searchBarStyle = .minimal
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.searchTextField.backgroundColor = .systemGray6
        searchTextField.searchTextField.layer.cornerRadius = 10
        searchTextField.searchTextField.clipsToBounds = true
        searchTextField.searchTextField.leftView?.tintColor = .systemGray
        
        view.addSubview(addTrackerIcon)
        view.addSubview(trackerDate)
        view.addSubview(trackerTextLabel)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        
                
        NSLayoutConstraint.activate([
            addTrackerIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addTrackerIcon.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addTrackerIcon.widthAnchor.constraint(equalToConstant: 42),
            addTrackerIcon.heightAnchor.constraint(equalTo: addTrackerIcon.widthAnchor),
            trackerDate.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerDate.centerYAnchor.constraint(equalTo: addTrackerIcon.centerYAnchor),
            trackerTextLabel.leadingAnchor.constraint(equalTo: addTrackerIcon.leadingAnchor, constant: 10),
            trackerTextLabel.topAnchor.constraint(equalTo: addTrackerIcon.bottomAnchor, constant: 1),
            searchTextField.topAnchor.constraint(equalTo: trackerTextLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        addTrackerIcon.addTarget(self, action: #selector(addTask), for: .touchUpInside)
    }
    
    func setupPlaceolder(){
        view.addSubview(placeholderView)
        placeholderView.addSubview(placeholderImageView)
        placeholderView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            placeholderImageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            placeholderImageView.topAnchor.constraint(equalTo: placeholderView.topAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.bottomAnchor.constraint(equalTo: placeholderView.bottomAnchor)
        ])
        
        
    }
    
    @objc func addTask(){
        let vc = NewTaskTrackerViewController()
        vc.title = "Новая привычка"
        let navVC = UINavigationController(rootViewController: vc)
        if let sheet = navVC.sheetPresentationController{
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(navVC, animated: true)
    }
    
    @objc private func dateChanged(){
        presenter.updateDate(date: trackerDate.date)
    }
}


extension TrackerViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfVisibleTrackers()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCollectionViewCell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        let tracker = presenter.tracker(at: indexPath.row)
        let isCompleted = presenter.isTrackerCompleted(tracker, on: presenter.currentDate)
        cell.configure(title: tracker.title, color: tracker.color, emoji: tracker.emoji, days: "0", isCompleted: isCompleted)
        cell.onDoneButtonTapped = { [weak self] in
            guard let self else { return }
            presenter.markTrackerCompleted(tracker, on: presenter.currentDate)
        }
        return cell
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 8
        let availableWidth = collectionView.bounds.width - padding * 2 - spacing
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
}

