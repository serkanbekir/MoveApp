//
//  ViewController.swift
//  MoveApp
//
//  Created by Serkan Bekir on 6.02.2021.
//

import UIKit

class SplashViewController: UIViewController {

    private enum Constants {
        static let errorTitle = "Error"
        static let errorMessage = "No network connection"
        static let okTitle = "Try again"
        static let storyboard = "Main"
        static let list = "ListViewController"
    }

    @IBOutlet weak var splashLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if RCValues.sharedInstance.fetchComplete {
            setSplashText()
        }
        RCValues.sharedInstance.loadingDoneCallback = setSplashText
        NetworkService.sharedInstance.statusCheckedCallback = showErrorIfNoConnection
    }

    private func showErrorIfNoConnection() {
        if NetworkService.sharedInstance.reachabilityStatus == .notReachable ||
            NetworkService.sharedInstance.reachabilityStatus == .unknown {
            showReachabilityError()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                guard let listViewController = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: Constants.list) as? ListViewController else { return }
                self.changeWindowRootController(listViewController)
            }
        }
    }

    private func showReachabilityError() {
        let alert = UIAlertController(title: Constants.errorTitle, message: Constants.errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constants.okTitle, style: UIAlertAction.Style.default, handler: { [weak self] _ in
            self?.showErrorIfNoConnection()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func changeWindowRootController(_ viewController: UIViewController) {
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }

    private func setSplashText() {
        splashLabel.text = RCValues.sharedInstance.string(forKey: .appSplashText)
    }
}

