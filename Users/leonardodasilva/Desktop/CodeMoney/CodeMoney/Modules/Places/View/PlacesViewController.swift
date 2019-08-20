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
  private let tableFooterIndicator = TableFooterIndicator()
  private let userLocation = FakeUserLocation()
  
  private var didReachEndOfList = false
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
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorColor = .clear
    tableView.tableFooterView = tableFooterIndicator
    
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
    output.didPullToRefresh()
  }
}

extension PlacesViewController: PlacesViewInput {
  func positionMap(atLatitude latitude: Double, longitude: Double) {
    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    userLocation.fakeCoordinate = location
    mapView.setCenter(location, animated: false)
  }
  
  func showInList(places: [Place]) {
    didReachEndOfList = false
    self.places = places
    tableView.reloadData()
  }
  
  func showMoreInList(places: [Place]) {
    didReachEndOfList = false
    let oldLastRow = self.places.count - 1
    self.places.append(contentsOf: places)
    let newLastRow = self.places.count - 1
    let rows =  Array((oldLastRow + 1)...newLastRow)
      .map { row in IndexPath(row: row, section: 0) }
    tableView.insertRows(at: rows, with: .none)
  }
  
  func showErrorWhileLoadingList() {
    let alert = UIAlertController(
      title: "Erro",
      message: "Não foi possível carregar os locais.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  func showReloadingListIndicator() {
    refreshControl.beginRefreshing()
  }
  
  func hideReloadingListIndicator() {
    refreshControl.endRefreshing()
  }
  
  func showLoadingMoreForListIndicator() {
    tableFooterIndicator.show()
    UIView.animate(withDuration: 0.2, animations: {
      self.tableView.contentInset.bottom = self.tableFooterIndicator.frame.height
    })
  }
  
  func hideLoadingMoreForListIndicator() {
    tableFooterIndicator.hide()
    UIView.animate(withDuration: 0.2, animations: {
      self.tableView.contentInset.bottom = self.tableFooterIndicator.frame.height
    })
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
    if indexPath.row == places.count - 1 && !didReachEndOfList {
      didReachEndOfList = true
      output.didReachEndOfList()
    }
    
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

fileprivate class TableFooterIndicator: UIView {
  private let activityIndicator = UIActivityIndicatorView(style: .gray)
  
  init() {
    super.init(frame: .zero)
    addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      activityIndicator.topAnchor.constraint(equalTo: self.topAnchor),
    ])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func hide() {
    activityIndicator.stopAnimating()
    frame = .zero
  }
  
  func show() {
    activityIndicator.startAnimating()
    frame = CGRect(origin: .zero, size: CGSize(width: 0, height: activityIndicator.frame.height + 18))
  }
}
