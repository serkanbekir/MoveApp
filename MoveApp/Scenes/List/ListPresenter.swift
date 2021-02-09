//
//  ListPresenter.swift
//  MoveApp
//
//  Created by Serkan Bekir on 7.02.2021.
//

import Foundation

protocol ListPresenterProtocol {

    func getSearchedItems(searchedText: String)
    func getItem(at index: Int) -> MovieUIModel?
    func numberOfRows() -> Int
}

class ListPresenter: Presenter {

    private enum Constants {
        static let apiKey = "apiKey"
        static let apiKeyValue = "4c11946e"
    }
    
    // MARK: - Dependencies
    
    private weak var viewController: ListViewControllerProtocol!

    // MARK: - Properties

    private var items: [MovieUIModel]?

    // MARK: - Initializers
    
    convenience init(viewController: ListViewControllerProtocol, networkService: NetworkService? = nil) {
        self.init(networkService: networkService)
        
        self.viewController = viewController
    }
}

extension ListPresenter: ListPresenterProtocol {

    func getItem(at index: Int) -> MovieUIModel? {
        return items?[index]
    }
    
    func numberOfRows() -> Int {
        return items?.count ?? 0
    }

    func getSearchedItems(searchedText: String) {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: Constants.apiKey, value: Constants.apiKeyValue))
        queryItems.append(URLQueryItem(name: "s", value: searchedText))
        networkService?.getSearchedItems(queryItems: queryItems, complition: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let items):
                self.items = items.map( { MovieUIModel(imageUrl: $0.Poster, title: $0.Title, year: $0.Year, type: $0.Type) })
                self.viewController.reloadTableView()
            case .failure(let error):
                print(error)
            }
        })
    }
}
