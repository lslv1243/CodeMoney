//
//  PlacesViewController.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 05/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import UIKit

class PlacesViewController: UITableViewController {
  private var places: [Place] = []
  private let placesClient = PlacesClient()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    tabBarItem.image = UIImage(named: "places_icon")
    tabBarItem.title = "Locais"
    view.backgroundColor = .white
    tableView.separatorColor = .clear
    
    refreshControl = UIRefreshControl()
    refreshControl!.addTarget(self, action: #selector(loadPlaces), for: .valueChanged)
    
    loadPlaces()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func loadPlaces() {
    refreshControl!.beginRefreshing()
    placesClient.listDistance(latitude: -27.0912233, longitude: -48.8892335)
      .done { places in
        self.places = places
        self.tableView.reloadData()
      }
      .catch { error in }
      .finally {
        self.refreshControl!.endRefreshing()
      }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return places.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = "PLACE_CELL"
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? PlaceTableViewCell
      ?? PlaceTableViewCell(reuseIdentifier: reuseIdentifier)
    let place = places[indexPath.row]
    cell.showPlace(place: place)
    return cell
  }
}
