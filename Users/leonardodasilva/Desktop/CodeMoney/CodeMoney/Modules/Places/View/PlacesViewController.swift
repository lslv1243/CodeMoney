//
//  PlacesPlacesViewController.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 20/08/2019.
//  Copyright © 2019 Code Money. All rights reserved.
//

import UIKit
import MapKit

class PlacesViewController: UIViewController {
  private let tableView = UITableView()
  private let mapView = MKMapView()
  private let refreshControl = UIRefreshControl()
  private let searchBar = PlacesSearchBar()
  private let userLocation = FakeUserLocation()
  
  private var places: [Place] = []
  
  var output: PlacesViewOutput!
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    view = stackView
    
    mapView.isHidden = true
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(tableView)
    stackView.addArrangedSubview(mapView)
    stackView.bringSubviewToFront(searchBar)
    
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self
    
    tabBarItem.image = UIImage(named: "places_icon")
    tabBarItem.title = "Locais"
    view.backgroundColor = .white
    tableView.separatorColor = .clear
    
    mapView.addAnnotation(userLocation)
    mapView.delegate = self
    
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshControlTarget), for: .valueChanged)
    
    let resignSearchBarFirstResponderTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignSearchBarFirstResponder))
    resignSearchBarFirstResponderTapGestureRecognizer.cancelsTouchesInView = false
    tableView.addGestureRecognizer(resignSearchBarFirstResponderTapGestureRecognizer)
    mapView.addGestureRecognizer(resignSearchBarFirstResponderTapGestureRecognizer)
    
    output.viewIsReady()
  }
  
  @objc func resignSearchBarFirstResponder() {
    searchBar.resignFirstResponder()
  }
  
  @objc func refreshControlTarget() {
    output.didPullToRefreshPlaces()
  }
}

extension PlacesViewController: PlacesViewInput {
  func positionMap(atLatitude latitude: Double, longitude: Double) {
    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    userLocation.fakeCoordinate = location
    mapView.setCenter(location, animated: false)
  }
  
  func showPlaces(_ places: [Place]) {
    self.places = places
    tableView.reloadData()
  }
  
  func showErrorWhileLoadingPlaces() {
    let alert = UIAlertController(
      title: "Erro",
      message: "Não foi possível carregar os locais.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  func showLoadingPlacesIndicator() {
    refreshControl.beginRefreshing()
  }
  
  func hideLoadingPlacesIndicator() {
    refreshControl.endRefreshing()
  }
}

extension PlacesViewController: PlacesSearchBarDelegate {
  func placesSearchBar(_ searchBar: PlacesSearchBar, didUpdateDisplayingMode toMode: PlacesSearchBar.DisplayingMode) {
    mapView.isHidden = toMode != .map
    tableView.isHidden = toMode != .list
  }
  
  func placesSearchBar(_ searchBar: PlacesSearchBar, didChangeText newText: String) {
    output.searchBarDidChangeText(newText)
  }
}

extension PlacesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return places.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = "PLACE_CELL"
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? PlaceTableViewCell
      ?? PlaceTableViewCell(reuseIdentifier: reuseIdentifier)
    let place = places[indexPath.row]
    cell.showPlace(place: place)
    return cell
  }
}

extension PlacesViewController: UITableViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    searchBar.resignFirstResponder()
  }
}

extension PlacesViewController: MKMapViewDelegate {
  func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    searchBar.resignFirstResponder()
  }
}

fileprivate class FakeUserLocation: MKUserLocation {
  var fakeCoordinate = CLLocationCoordinate2D()
  override var coordinate: CLLocationCoordinate2D {
    return fakeCoordinate
  }
}
