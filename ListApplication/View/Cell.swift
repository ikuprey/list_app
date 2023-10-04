import UIKit

class Cell: UITableViewCell {

    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if var placeholder = UIImage(systemName: "photo") {
            placeholder = placeholder.withRenderingMode(.alwaysTemplate)
            imageView.image = placeholder.withTintColor(.gray)
            imageView.tintColor = .systemGray
        }

        return imageView
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkText
        return label
    }()

    private lazy var confidence: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        return label
    }()

    private lazy var id: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        return label
    }()

    private lazy var container: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(white: 0.9, alpha: 1)
        container.layer.cornerRadius = 8
        container.layer.shadowColor = UIColor(white: 0, alpha: 0.4).cgColor
        container.layer.shadowOpacity = 1
        container.layer.shadowOffset = CGSize(width: 5, height: 5)
        container.layer.shadowRadius = 5
        return container
    }()


    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        config()
    }

    public func setup(title: String, id: String, confidence: CGFloat) {
        self.title.text = title
        self.id.text = "id: \(id)"
        self.confidence.text = String(format: "confidence: %.2f", confidence)
    }

    public func load(image: Data) {
        DispatchQueue.main.async {
            UIView.transition(with: self.image, duration: 0.4) {
                self.image.image = UIImage(data: image)
            }
        }
    }

    private func config() {
        let padding: CGFloat = 20

        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])

        container.addSubview(image)
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),
            image.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            image.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            image.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding),
        ])

        let stack = UIStackView(arrangedSubviews: [title, id, confidence])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            stack.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
        ])
    }
}

