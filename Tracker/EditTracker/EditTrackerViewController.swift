import Foundation
import UIKit

final class EditTrackerViewController: UIViewController{
    private let dayTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .blackDay
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .backgroundDay
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.clearButtonMode = .whileEditing
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let menuTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .customGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(EditTrackerTableViewCell.self, forCellReuseIdentifier: EditTrackerTableViewCell.identifier)
        return tableView
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
        collectionView.register(EditTrackerCollectionViewCell.self, forCellWithReuseIdentifier: EditTrackerCollectionViewCell.identifier)
        collectionView.register(EditTrackerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EditTrackerSectionHeaderView.identifier)
        return collectionView
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
    
    private let tracker: Tracker
    private var category: String?
    private let completedDay: Int
    
    var presenter = EditTrackerViewControllerPresenter()
    var onSave: ((Tracker, String) -> Void)?
    
    var trackerCategoryStore: TrackerCategoryStore?
    
    private let menuTableViewItem = ["Категория","Расписание"]
    private var selectedEmojiIndex: Int?
    private var selectedColorIndex: Int?
    let colorItem: [UIColor] = [.colorSection1, .colorSection2, .colorSection3, .colorSection4,
                                .colorSection5, .colorSection6, .colorSection7, .colorSection8,
                                .colorSection9, .colorSection10, .colorSection11, .colorSection12,
                                .colorSection13, .colorSection14, .colorSection15, .colorSection16,
                                .colorSection17, .colorSection18]
    
    private lazy var sections: [NewTaskElementSection] = [
        NewTaskElementSection(title: "Emoji", element: emojiItem.map({.emoji($0)})),
        NewTaskElementSection(title: "Цвет", element: colorItem.map({.color($0)}))
    ]
    
    init(tracker: Tracker, category: String, completedDay: Int) {
        self.tracker = tracker
        self.category = category
        self.completedDay = completedDay
        print(tracker.color, tracker.emoji)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupUI()
        presenter.setSchedule(tracker.schedule)
        fillData()
        updateCreateButtonState()
        
    }
    
    @objc private func didTapCreateButton(){
        guard let selectedColorIndex, let selectedEmojiIndex else { return }
        guard let category else { return }
        let updated = Tracker(
            id: tracker.id,
            title: nameTrackerTextField.text ?? tracker.title,
            color: colorItem[selectedColorIndex],
            emoji: emojiItem[selectedEmojiIndex],
            schedule: presenter.schedule)
        
        onSave?(updated, category)
        dismiss(animated: true)
    }
    
    @objc private func didTapCancelButton(){
        self.dismiss(animated: true)
    }
    
    func fillData(){
        dayTitleLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays",tableName: "LocalizableDict",  comment: ""),
            completedDay
        )
        nameTrackerTextField.text = tracker.title
        selectedColorIndex = colorItem.firstIndex(where: { isSameColor($0, tracker.color) })
        selectedEmojiIndex = emojiItem.firstIndex(of: tracker.emoji)
    }
    
    func setupUI(){
        view.addSubview(dayTitleLabel)
        view.addSubview(nameTrackerTextField)
        view.addSubview(menuTableView)
        view.addSubview(collectionView)
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            dayTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            dayTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dayTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dayTitleLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: dayTitleLabel.bottomAnchor, constant: 40),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            menuTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuTableView.heightAnchor.constraint(equalToConstant: 200),
            
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
    
    func updateCreateButtonState(){
        let hasTitle = !(nameTrackerTextField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        createButton.isEnabled = hasTitle
        && category != nil
        && presenter.selectedDaysNotEmpty()
        && selectedEmojiIndex != nil
        && selectedColorIndex != nil
        createButton.backgroundColor = createButton.isEnabled ? .blackDay : .customGray
    }
    
    private func isSameColor(_ c1: UIColor, _ c2: UIColor) -> Bool {
        let c1 = c1.resolvedColor(with: traitCollection)
        let c2 = c2.resolvedColor(with: traitCollection)

        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        c1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        c2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return abs(r1 - r2) < 0.01 && abs(g1 - g2) < 0.01 && abs(b1 - b2) < 0.01
    }
}

extension EditTrackerViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTableViewItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditTrackerTableViewCell") as? EditTrackerTableViewCell else { return UITableViewCell() }
        
        if indexPath.row == 0{
            cell.configure(with: menuTableViewItem[indexPath.row], subtitle: category)
        }else{
            cell.configure(with: menuTableViewItem[indexPath.row], subtitle: presenter.scheduleSubtitle)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension EditTrackerViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            guard let trackerCategoryStore else {
                print("trackerCategoryStore == nil")
                return
            }
            
            let vc = CategoryViewController()
            vc.title = "Категория"
            vc.viewModel = CategoryViewModel(
                store: trackerCategoryStore,
                selectedCategory: category
            )
            
            vc.onCategorySelected = { [weak self] title in
                guard let self else { return }
                self.category = title
                self.menuTableView.reloadData()
                self.updateCreateButtonState()
            }
            
            vc.viewModel?.onSelectedCategoryDeleted = { [weak self] in
                guard let self else { return }
                self.category = nil
                self.menuTableView.reloadData()
                self.updateCreateButtonState()
            }
            
            vc.viewModel?.onSelectedCategoryRenamed = { [weak self] newTitle in
                guard let self else { return }
                self.category = newTitle
                self.menuTableView.reloadData()
            }
            
            let navVC = UINavigationController(rootViewController: vc)
            if let sheet = navVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
            }
            
            present(navVC, animated: true)
        }else{
            let vc = ScheduleTrackerViewController()
            vc.title = "Расписание"
            vc.selectedDays = presenter.setSelectedDays()
            
            vc.onScheduleSelected = { [weak self] days in
                guard let self else { return }
                self.presenter.updateSchedule(days)
                self.menuTableView.reloadData()
                
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


extension EditTrackerViewController: UICollectionViewDataSource{
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
                withReuseIdentifier: EditTrackerCollectionViewCell.identifier,
                for: indexPath
            ) as? EditTrackerCollectionViewCell else { return UICollectionViewCell() }
            let isSelected = (selectedEmojiIndex == indexPath.item)
            cell.configure(element: emoji, isSelected: isSelected)
            return cell
        case .color(let color):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EditTrackerCollectionViewCell.identifier,
                for: indexPath
            ) as? EditTrackerCollectionViewCell else { return UICollectionViewCell() }
            let isSelected = (selectedColorIndex == indexPath.item)
            cell.configure(with: color, isSelected: isSelected)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: EditTrackerSectionHeaderView.identifier,
                for: indexPath
              ) as? EditTrackerSectionHeaderView else {
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
        updateCreateButtonState()
    }
}

extension EditTrackerViewController: UICollectionViewDelegateFlowLayout{
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
