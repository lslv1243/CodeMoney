//
//  PlacesPlacesPresenter.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 20/08/2019.
//  Copyright © 2019 Code Money. All rights reserved.
//

class PlacesPresenter {
  private var searching = ""
  private var currentLatitude = -27.0912233
  private var currentLongitude = -48.8892335
  
  weak var view: PlacesViewInput!
  var interactor: PlacesInteractorInput!
  var router: PlacesRouterInput!
}

extension PlacesPresenter: PlacesModuleInput {
  
}

extension PlacesPresenter: PlacesViewOutput {
  func viewIsReady() {
    view.positionMap(atLatitude: currentLatitude, longitude: currentLongitude)
    view.showLoadingPlacesIndicator()
    interactor.reloadPlaces(forLatitude: currentLatitude, longitude: currentLongitude, search: searching)
  }
  
  func searchBarDidChangeText(_ text: String) {
    searching = text
    view.showLoadingPlacesIndicator()
    interactor.reloadPlaces(forLatitude: currentLatitude, longitude: currentLongitude, search: searching)
  }
  
  func didPullToRefreshPlaces() {
    interactor.reloadPlaces(forLatitude: currentLatitude, longitude: currentLongitude, search: searching)
  }
}

extension PlacesPresenter: PlacesInteractorOutput {
  func didLoadPlaces(places: [Place]) {
    view.hideLoadingPlacesIndicator()
    view.showPlaces(places)
  }
  
  func didFailLoadingPlaces(error: Error) {
    view.hideLoadingPlacesIndicator()
    view.showErrorWhileLoadingPlaces()
  }
}
