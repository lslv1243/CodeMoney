//
//  WithdrawalsViewController.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 05/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import UIKit

class WithdrawalsViewController: UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
    tabBarItem.image = UIImage(named: "withdrawals_icon")
    tabBarItem.title = "Saques"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
