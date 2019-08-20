//
//  PlacesViewController.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 05/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import UIKit
import MapKit

class PlacesViewController: UIViewController {
  private var places: [Place] = []
  private let placesClient = PlacesClient()
  private let tableView = UITableView()
  private let mapView = MKMapView()
  private let refreshControl = UIRefreshControl()
  private let searchBar = PlacesSearchBar()
  
  private var searching = ""
  private var currentLatitude = -27.0912233
  private var currentLongitude = -48.8892335
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
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
    
    let location = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
    let userLocation = FakeUserLocation()
    userLocation.fakeCoordinate = location
    mapView.setCenter(location, animated: false)
    mapView.addAnnotation(userLocation)
    mapView.delegate = self
    
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshControlTarget), for: .valueChanged)
    
    let resignSearchBarFirstResponderTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignSearchBarFirstResponder))
    resignSearchBarFirstResponderTapGestureRecognizer.cancelsTouchesInView = false
    tableView.addGestureRecognizer(resignSearchBarFirstResponderTapGestureRecognizer)
    mapView.addGestureRecognizer(resignSearchBarFirstResponderTapGestureRecognizer)

    reloadPlaces()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func resignSearchBarFirstResponder() {
    searchBar.resignFirstResponder()
  }
  
  @objc func refreshControlTarget() {
    reloadPlaces()
  }
  
  func reloadPlaces() {
    refreshControl.beginRefreshing()
    placesClient.listDistance(latitude: currentLatitude, longitude: currentLongitude, search: searching)
      .done { places in
        self.places = places
        self.tableView.reloadData()
      }
      .catch { error in }
      .finally {
        self.refreshControl.endRefreshing()
      }
  }
}

extension PlacesViewController: PlacesSearchBarDelegate {
  func placesSearchBar(_ searchBar: PlacesSearchBar, didUpdateDisplayingMode toMode: PlacesSearchBar.DisplayingMode) {
    mapView.isHidden = toMode != .map
    tableView.isHidden = toMode != .list
  }
  
  func placesSearchBar(_ searchBar: PlacesSearchBar, didChangeText newText: String) {
    searching = newText
    reloadPlaces()
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
