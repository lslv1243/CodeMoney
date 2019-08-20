//
//  PlacesPlacesViewOutput.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 20/08/2019.
//  Copyright © 2019 Code Money. All rights reserved.
//

protocol PlacesViewOutput {
  
  /**
   @author Leonardo da Silva
   Notify presenter that view is ready
   */
  
  func viewIsReady()
  func searchBarDidChangeText(_ text: String)
  func didPullToRefresh()
  func didReachEndOfList()
}
