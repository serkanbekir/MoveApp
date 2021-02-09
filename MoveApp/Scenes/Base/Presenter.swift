//
//  Presenter.swift
//  MoveApp
//
//  Created by Serkan Bekir on 7.02.2021.
//

import Foundation

protocol PresenterProtocol {
    
}

class Presenter {
    
    // MARK: - Properties
    
    let networkService: NetworkService?
    
    // MARK: - Initializers
    
    init(networkService: NetworkService?) {
        self.networkService = networkService
    }
}

extension Presenter: PresenterProtocol {
    
}
