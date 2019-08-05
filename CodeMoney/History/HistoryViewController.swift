//
//  HistoryViewController.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 05/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
    tabBarItem.image = UIImage(named: "history_icon")
    tabBarItem.title = "Histórico"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
