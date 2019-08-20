//
//  PlacesPlacesViewInput.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 20/08/2019.
//  Copyright © 2019 Code Money. All rights reserved.
//

protocol PlacesViewInput: class {
  
  /**
   @author Leonardo da Silva
   Setup initial state of the view
   */
  
  func positionMap(atLatitude latitude: Double, longitude: Double)
  
  func showLoadingPlacesIndicator()
  func hideLoadingPlacesIndicator()
  func showPlaces(_ places: [Place])
  func showErrorWhileLoadingPlaces()
}
