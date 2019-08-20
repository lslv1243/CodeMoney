//
//  PlacesPlacesInteractor.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 20/08/2019.
//  Copyright © 2019 Code Money. All rights reserved.
//

class PlacesInteractor {
  private let placesClient = PlacesClient()
  private var currentPage = 0
  
  weak var output: PlacesInteractorOutput!
}

extension PlacesInteractor: PlacesInteractorInput {
  func reloadPlaces(forLatitude latitude: Double, longitude: Double, search: String) {
    currentPage = 0
    loadPlaces(forLatitude: latitude, longitude: longitude, search: search)
  }
  
  func loadMorePlaces(forLatitude latitude: Double, longitude: Double, search: String) {
    currentPage += 1
    loadPlaces(forLatitude: latitude, longitude: longitude, search: search)
  }
  
  private func loadPlaces(forLatitude latitude: Double, longitude: Double, search: String) {
    let page = self.currentPage
    placesClient.listDistance(latitude: latitude, longitude: longitude, search: search, page: page)
      .done { places in
        self.output.didLoadPlaces(places: places, forPage: page)
      }
      .catch { error in
        self.output.didFailLoadingPlaces(error: error, forPage: page)
      }
  }
}
