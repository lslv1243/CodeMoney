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
  
  func showReloadingListIndicator()
  func hideReloadingListIndicator()
  func showLoadingMoreForListIndicator()
  func hideLoadingMoreForListIndicator()
  func showInList(places: [Place])
  func showMoreInList(places: [Place])
  func showErrorWhileLoadingList()
}
