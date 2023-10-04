import UIKit

class DetailedViewController<ViewModel: DetailedViewModelProtocol>: UIViewController {

    var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        if var placeholder = UIImage(systemName: "photo") {
            placeholder = placeholder.withRenderingMode(.alwaysTemplate)
            image.image = placeholder.withTintColor(.gray)
            image.tintColor = .systemGray
        }

        return image
    }()

    private lazy var header: UILabel = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = self.viewModel.title
        header.text = "Text: \(viewModel.title)"
        id.text = "Id: \(viewModel.id)"
        confidence.text = "Confidence: \(viewModel.confidence)"

        config()
    }

    private func config() {
        let padding: CGFloat = 20
        view.addSubview(image)
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            image.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
        ])

        let stack = UIStackView(arrangedSubviews: [header, id, confidence])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: image.bottomAnchor, constant: padding),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
        ])

    }

    public func load(image: Data) {
        DispatchQueue.main.async {
            UIView.transition(with: self.image, duration: 0.4) {
                self.image.image = UIImage(data: image)
            }
        }
    }
    
}
