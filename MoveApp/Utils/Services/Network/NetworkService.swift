//
//  NetworkService.swift
//  MoveApp
//
//  Created by Serkan Bekir on 7.02.2021.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {

}

class NetworkService: NetworkServiceProtocol {

    private enum NetworkConstants {
        static let search = "https://www.omdbapi.com/"
    }

    static let sharedInstance = NetworkService()

    private var reachabilityManager: NetworkReachabilityManager?
    var reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    var statusCheckedCallback: (() -> Void)?

    // MARK: - Reachability
    
    func startReachability(listener: NetworkReachabilityManager.Listener? = nil) {
        reachabilityManager = NetworkReachabilityManager(host: "www.google.com")

        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            guard let self = self else { return }
            self.reachabilityStatus = status
            self.statusCheckedCallback?()
            
            if let listener = listener {
                listener(status)
            }
        })
    }
    
    func stopReachabilityManager() {
        reachabilityManager?.stopListening()
    }
    
    func getSearchedItems(queryItems: [URLQueryItem], complition: @escaping (Result<[SearchItemModel], LError>) -> Void) {
        guard var urlComponent = URLComponents(string: NetworkConstants.search) else {
            complition(.failure(.invalidURL))
            return
        }
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            complition(.failure(.invalidURL))
            return
        }

        AF.request(url).validate().responseDecodable(of: SearchResponseModel.self) { [weak self] response in
            guard let films = response.value else { return
                complition(.failure(.invalidResponse))
            }
            complition(.success(films.Search))
        }
    }
}
