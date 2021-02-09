//
//  ListViewController.swift
//  MoveApp
//
//  Created by Serkan Bekir on 7.02.2021.
//

import UIKit

protocol ListViewControllerProtocol: class {
    
    func reloadTableView()
}

class ListViewController: UIViewController {

    private enum Constants {
        static let title = "Movies"
        static let emptyMessage = "Nothing to show :("
    }

    // MARK: Dependencies

    private var presenter: ListPresenterProtocol!

    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties

    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect.zero)

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Constants.title
        injectDependencies()
        configureView()
    }

    private func injectDependencies() {
        presenter = ListPresenter(viewController: self, networkService: NetworkService.sharedInstance)
    }
 
    private func configureView() {
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: MovieTableViewCell.cellIdentifier)
        configureSearchBar()
    }

    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
}

extension ListViewController: ListViewControllerProtocol {

    func reloadTableView() {
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.numberOfRows() == 0 {
            self.tableView.setEmptyMessage(Constants.emptyMessage)
        } else {
            self.tableView.restore()
        }
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let movie = presenter.getItem(at: indexPath.row) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellIdentifier) as? MovieTableViewCell {
                cell.configure(with: movie)
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text {
            presenter.getSearchedItems(searchedText: searchedText)
        }
    }
}
extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
