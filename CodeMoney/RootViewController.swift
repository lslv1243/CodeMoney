//
//  ViewController.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 05/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tabBar.tintColor = .orange
    
    setViewControllers([
      WalletViewController(),
      HistoryViewController(),
      PayViewController(),
      PlacesViewController(),
      WithdrawalsViewController(),
    ], animated: false)
  }
}


