import UIKit

enum OrderBy: Int {
    case years = 0
    case coffees
    case bugs
}

protocol Sortable: NSObject {
    func sort(with index: OrderBy)
}

class OrderByTableViewController: UITableViewController {
    private weak var delegate: Sortable?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        if indexPath.row == 0 {
            cell?.textLabel?.text = "Years"
        } else if indexPath.row == 1 {
            cell?.textLabel?.text = "Coffees"
        } else {
            cell?.textLabel?.text = "Bugs"
        }
        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.sort(with: OrderBy(rawValue: indexPath.row) ?? .years)
        dismiss(animated: true)
    }

}

extension OrderByTableViewController {
    func setOrderByHander(delegate: Sortable) {
        self.delegate = delegate
    }
}
