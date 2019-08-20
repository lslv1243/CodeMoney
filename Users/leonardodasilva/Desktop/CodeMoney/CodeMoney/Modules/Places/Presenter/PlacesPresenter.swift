//
//  PlacesPlacesPresenter.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 20/08/2019.
//  Copyright © 2019 Code Money. All rights reserved.
//

class PlacesPresenter {
  private var hasMorePages = false
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
    view.showReloadingListIndicator()
    interactor.reloadPlaces(forLatitude: currentLatitude, longitude: currentLongitude, search: searching)
  }
  
  func searchBarDidChangeText(_ text: String) {
    searching = text
    view.showReloadingListIndicator()
    interactor.reloadPlaces(forLatitude: currentLatitude, longitude: currentLongitude, search: searching)
  }
  
  func didPullToRefresh() {
    interactor.reloadPlaces(forLatitude: currentLatitude, longitude: currentLongitude, search: searching)
  }
  
  func didReachEndOfList() {
    guard hasMorePages else { return }
    
    view.showLoadingMoreForListIndicator()
    interactor.loadMorePlaces(forLatitude: currentLatitude, longitude: currentLongitude, search: searching)
  }
}

extension PlacesPresenter: PlacesInteractorOutput {
  func didLoadPlaces(places: [Place], forPage page: Int) {
    hasMorePages = places.count > 0
    
    if page == 0 {
      view.hideReloadingListIndicator()
      view.showInList(places: places)
    } else {
      view.hideLoadingMoreForListIndicator()
      if places.count > 0 {
        view.showMoreInList(places: places)
      }
    }
  }
  
  func didFailLoadingPlaces(error: Error, forPage page: Int) {
    if page == 0 {
      view.hideReloadingListIndicator()
    } else {
      view.hideLoadingMoreForListIndicator()
    }
    view.showErrorWhileLoadingList()
  }
}
