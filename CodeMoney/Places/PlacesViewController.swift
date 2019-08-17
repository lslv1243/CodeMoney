//
//  PlacesViewController.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 05/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PlacesSearchBarDelegate {
  private var places: [Place] = []
  private let placesClient = PlacesClient()
  private let tableView = UITableView()
  private let refreshControl = UIRefreshControl()
  private let searchBar = PlacesSearchBar()
  private var searching = ""
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    view = stackView
    
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(tableView)
    stackView.bringSubviewToFront(searchBar)
    
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self
    
    tabBarItem.image = UIImage(named: "places_icon")
    tabBarItem.title = "Locais"
    view.backgroundColor = .white
    tableView.separatorColor = .clear
    
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshControlTarget), for: .valueChanged)
    
    let resignSearchBarFirstResponderTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignSearchBarFirstResponder))
    resignSearchBarFirstResponderTapGestureRecognizer.cancelsTouchesInView = false
    tableView.addGestureRecognizer(resignSearchBarFirstResponderTapGestureRecognizer)

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
    placesClient.listDistance(latitude: -27.0912233, longitude: -48.8892335, search: searching)
      .done { places in
        self.places = places
        self.tableView.reloadData()
      }
      .catch { error in }
      .finally {
        self.refreshControl.endRefreshing()
      }
  }
  
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
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    searchBar.resignFirstResponder()
  }
  
  func placesSearchBar(_ searchBar: PlacesSearchBar, didUpdateDisplayingMode toMode: PlacesSearchBar.DisplayingMode) {
    // TODO: change center view from list to map and vice versa
  }
  
  func placesSearchBar(_ searchBar: PlacesSearchBar, didChangeText newText: String) {
    searching = newText
    reloadPlaces()
  }
}
