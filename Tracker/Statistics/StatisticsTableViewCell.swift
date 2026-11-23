import UIKit

class StatisticsTableViewCell: UITableViewCell {
    
    static let identifier = "StatisticsTableViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.99, green: 0.30, blue: 0.29, alpha: 1).cgColor,
            UIColor(red: 0.27, green: 0.90, blue: 0.62, alpha: 1).cgColor,
            UIColor(red: 0.00, green: 0.48, blue: 0.98, alpha: 1).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }()

    private let borderMask: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        return layer
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.layer.addSublayer(gradientLayer)
        gradientLayer.mask = borderMask
        containerView.addSubview(countLabel)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            countLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            countLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: countLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: countLabel.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded() 
        gradientLayer.frame = containerView.bounds
        borderMask.path = UIBezierPath(
            roundedRect: containerView.bounds.insetBy(dx: 0.5, dy: 0.5),
            cornerRadius: 16
        ).cgPath
    }
    
    func configure(count: Int, title: String) {
        countLabel.text = "\(count)"
        titleLabel.text = title
    }
}
