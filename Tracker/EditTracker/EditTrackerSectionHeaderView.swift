import UIKit

final class EditTrackerSectionHeaderView: UICollectionReusableView{
    static var identifier = "EditTrackerSectionHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
        
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
    func configure(with title: String) {
        titleLabel.text = title
    }
}
