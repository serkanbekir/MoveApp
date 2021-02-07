//
//  NetworkService.swift
//  MoveApp
//
//  Created by Serkan Bekir on 7.02.2021.
//

import Foundation
import Alamofire

class NetworkService {

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
}
