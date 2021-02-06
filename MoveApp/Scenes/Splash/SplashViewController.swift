//
//  ViewController.swift
//  MoveApp
//
//  Created by Serkan Bekir on 6.02.2021.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var splashLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if RCValues.sharedInstance.fetchComplete {
            setSplashText()
        }
        RCValues.sharedInstance.loadingDoneCallback = setSplashText
    }

    private func setSplashText() {
        splashLabel.text = RCValues.sharedInstance.string(forKey: .appSplashText)
    }
}

