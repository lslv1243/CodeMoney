//
//  PlacesPlacesInteractorOutput.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 20/08/2019.
//  Copyright © 2019 Code Money. All rights reserved.
//

import Foundation

protocol PlacesInteractorOutput: class {
  func didLoadPlaces(places: [Place], forPage page: Int)
  func didFailLoadingPlaces(error: Error, forPage page: Int)
}
