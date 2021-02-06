//
//  RCValues.swift
//  MoveApp
//
//  Created by Serkan Bekir on 6.02.2021.
//

import Firebase

enum ValueKey: String {
    case appSplashText
}

class RCValues {
    
    private enum Constants {
        static let remoteConfigSlashTextDefault = "Default Text"
    }
    
    static let sharedInstance = RCValues()
    
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete = false
    
    private init() {
        fetchCloudValues()
    }

    private func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            ValueKey.appSplashText.rawValue: Constants.remoteConfigSlashTextDefault
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    private func activateDebugMode() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
    private func fetchCloudValues() {
        activateDebugMode()
        
        RemoteConfig.remoteConfig().fetch { [weak self] _, error in
            if let error = error {
                print("Got an error fetching remote values \(error)")
                self?.fetchComplete = true
                DispatchQueue.main.async {
                    self?.loadingDoneCallback?()
                }
                return
            }
            
            RemoteConfig.remoteConfig().activate {[weak self] _, _ in
                self?.fetchComplete = true
                DispatchQueue.main.async {
                    self?.loadingDoneCallback?()
                }
            }
        }
    }
    
    func string(forKey key: ValueKey) -> String {
        return RemoteConfig.remoteConfig()[key.rawValue]
            .stringValue ?? Constants.remoteConfigSlashTextDefault
    }
}
