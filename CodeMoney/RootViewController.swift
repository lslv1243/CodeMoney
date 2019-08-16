//
//  ViewController.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 05/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    tabBar.tintColor = .orange
    
    setViewControllers([
      WalletViewController(),
      HistoryViewController(),
      PayViewController(),
      PlacesViewController(),
      WithdrawalsViewController(),
    ], animated: false)
  
    selectedIndex = 3
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


