import UIKit

class ViewController: UIViewController {

    // Could be injected from the outside instead of direct init
    private var viewModel: any ViewModelProtocol = {
        ViewModel(with: DataProvider())
    }()

    private lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.estimatedRowHeight = UITableView.automaticDimension
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(Cell.self, forCellReuseIdentifier: "Cell")
        return table
    }()

    private lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(responder:)), for: .valueChanged)
        return refresh
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List"

        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.refreshControl = refresh
        viewModel.refresh { [weak self] in
            guard let self else {
                return
            }

            self.table.reloadData()
        }
    }

    @objc private func refresh(responder: UIRefreshControl) {
        viewModel.refresh { [weak self] in
            guard let self else {
                return
            }

            responder.endRefreshing()
            self.table.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        let item = viewModel.items[indexPath.row]
        cell.setup(title: item.text, id: item.id, confidence: item.confidence)

        Task {
            do {
                let result = try await viewModel.image(for: item)
                cell.load(image: result)
            } catch {
                print(error)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // scrolled to the last - load new portion
        if indexPath.row + 1 == viewModel.items.count {
            viewModel.load(since: viewModel.items.last) { [weak self] updated in
                guard let self, updated else {
                    return
                }

                self.table.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel.items.count < 0 else {
            return nil
        }

        let text = UILabel()
        text.lineBreakMode = .byWordWrapping
        text.numberOfLines = 0
        text.textColor = .lightGray
        text.text = viewModel.message
        text.textAlignment = .center
        return text
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard viewModel.items.count < 0 else {
            return .zero
        }

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Possible way of navigation add coordinator and path the route or just callback via viewModel/controller or etc
        // for this simple case - just modal presentation here

        let item = viewModel.items[indexPath.row]
        let model = DetailedViewModel(item: item)
        let controller = DetailedViewController(viewModel: model)


        if let navigationController {
            navigationController.pushViewController(controller, animated: true)
            Task {
                do {
                    let result = try await self.viewModel.image(for: item)
                    controller.load(image: result)
                } catch {
                    print(error)
                }
            }
        } else {
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true) { [weak self] in
                guard let self else {
                    return
                }

                Task {
                    do {
                        let result = try await self.viewModel.image(for: item)
                        controller.load(image: result)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
