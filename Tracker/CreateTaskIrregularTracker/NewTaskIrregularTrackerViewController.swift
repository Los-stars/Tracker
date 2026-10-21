//
//  NewTaskIrregularTrackerViewController.swift
//  Tracker
//
//  Created by Amir on 05.10.2026.
//

import UIKit

final class NewTaskIrregularTrackerViewController: UIViewController{
    
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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isMultipleTouchEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(NewTaskIrregularTrackerCollectionViewCell.self, forCellWithReuseIdentifier: NewTaskIrregularTrackerCollectionViewCell.identifier)
        collectionView.register(NewTaskIrregularTrackerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NewTaskIrregularTrackerSectionHeaderView.identifier)
        return collectionView
    }()
    
    private let menuTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(NewTaskIrregularTrackerTableViewCell.self, forCellReuseIdentifier: NewTaskIrregularTrackerTableViewCell.identifier)
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
//        button.isEnabled = false
        
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

    var trackerStore: TrackerStore?
    var delegate: NewTaskTrackerDelegate?
    private let presenter = NewTaskIrregularTrackerViewControllerPresenter()
    var menuTableViewItem = ["Категория"]
    let emojiItem: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                     "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                     "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    let colorItem: [UIColor] = [.colorSection1, .colorSection2, .colorSection3, .colorSection4,
                                .colorSection5, .colorSection6, .colorSection7, .colorSection8,
                                .colorSection9, .colorSection10, .colorSection11, .colorSection12,
                                .colorSection13, .colorSection14, .colorSection15, .colorSection16,
                                .colorSection17, .colorSection18]
    private var selectedEmojiIndex: Int?
    private var selectedColorIndex: Int?
    private lazy var sections: [NewTaskElementSection] = [
        NewTaskElementSection(title: "Emoji", element: emojiItem.map({.emoji($0)})),
        NewTaskElementSection(title: "Цвет", element: colorItem.map({.color($0)}))
    ]
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
        view.addSubview(collectionView)
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            nameTrackerTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            limitLabel.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 8),
            limitLabel.leadingAnchor.constraint(equalTo: nameTrackerTextField.leadingAnchor),
            limitLabel.trailingAnchor.constraint(equalTo: nameTrackerTextField.trailingAnchor),
            menuTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuTableView.heightAnchor.constraint(equalToConstant: 120),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: menuTableView.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
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
        guard let emojiIndex = selectedEmojiIndex else { return }
        guard let colorIndex = selectedColorIndex else { return }
        
        let selectedEmoji = emojiItem[emojiIndex]
        let selectedColor = colorItem[colorIndex]
        let tracker = Tracker(title: title, color: selectedColor, emoji: selectedEmoji, schedule: Schedule.everyday)
        let category = TrackerCategory(title: "Домашний уют", trackers: [])
        do {
            guard let trackerStore else { return }
            try trackerStore.saveTracker(tracker: tracker, category: category)
            delegate?.didCreateTracker(tracker: tracker, category: category.title)
            dismiss(animated: true)
        } catch {
            print("Error saving tracker: \(error)")
        }
    }
}

extension NewTaskIrregularTrackerViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTableViewItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewTaskIrregularTrackerTableViewCell") as? NewTaskIrregularTrackerTableViewCell else { return UITableViewCell() }
        
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

extension NewTaskIrregularTrackerViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        limitLabel.isHidden = presenter.checkTextRange(to: updatedText)
        return presenter.checkTextRange(to: updatedText)
    }
}

extension NewTaskIrregularTrackerViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            print("Tap Category")
        }
    }
}

extension NewTaskIrregularTrackerViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].element.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].element[indexPath.item]
        
        switch item{
        case .emoji(let emoji):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewTaskIrregularTrackerCollectionViewCell.identifier,
                for: indexPath
            ) as? NewTaskIrregularTrackerCollectionViewCell else { return UICollectionViewCell() }
            let isSelected = (selectedEmojiIndex == indexPath.item)
            cell.configue(element: emoji, isSelected: isSelected)
            return cell
        case .color(let color):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewTaskIrregularTrackerCollectionViewCell.identifier,
                for: indexPath
            ) as? NewTaskIrregularTrackerCollectionViewCell else { return UICollectionViewCell() }
            let isSelected = (selectedColorIndex == indexPath.item)
            cell.configue(with: color, isSelected: isSelected)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: NewTaskIrregularTrackerSectionHeaderView.identifier,
                for: indexPath
              ) as? NewTaskIrregularTrackerSectionHeaderView else {
            return UICollectionReusableView()
        }
        
        let title = sections[indexPath.section].title
        header.configure(with: title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 0:
            selectedEmojiIndex = indexPath.item
        case 1:
            selectedColorIndex = indexPath.item
        default:
            break
        }
        
        collectionView.reloadData()
    }
}

extension NewTaskIrregularTrackerViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 6
        let padding: CGFloat = 16
        let sectionInset: CGFloat = 16
        
        let totalSpacing = padding * (itemsPerRow - 1) + sectionInset * 2
        let width = (collectionView.bounds.width - totalSpacing) / itemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}
