//
//  PlacesPlacesInteractor.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 20/08/2019.
//  Copyright © 2019 Code Money. All rights reserved.
//

class PlacesInteractor {
  private let placesClient = PlacesClient()
  
  weak var output: PlacesInteractorOutput!
}

extension PlacesInteractor: PlacesInteractorInput {
  func reloadPlaces(forLatitude latitude: Double, longitude: Double, search: String) {
    placesClient.listDistance(latitude: latitude, longitude: longitude, search: search)
      .done { places in
        self.output.didLoadPlaces(places: places)
      }
      .catch { error in
        self.output.didFailLoadingPlaces(error: error)
      }
  }
}
