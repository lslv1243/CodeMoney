//
//  PlacesPlacesInteractorInput.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 20/08/2019.
//  Copyright © 2019 Code Money. All rights reserved.
//

import Foundation

protocol PlacesInteractorInput {
  func reloadPlaces(forLatitude latitude: Double, longitude: Double, search: String)
  func loadMorePlaces(forLatitude latitude: Double, longitude: Double, search: String)
}
