//
//  PlacesPlacesInitializer.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 20/08/2019.
//  Copyright © 2019 Code Money. All rights reserved.
//

import UIKit

class PlacesModuleInitializer: NSObject {
  
  var placesViewController = PlacesViewController()
  
  override func awakeFromNib() {
    
    let configurator = PlacesModuleConfigurator()
    configurator.configureModuleForViewInput(viewInput: placesViewController)
  }
  
}
