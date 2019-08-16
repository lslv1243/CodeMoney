//
//  PlaceTableViewCell.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 06/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit

class PlaceTableViewCell: UITableViewCell {
  private let distanceFormatter = MKDistanceFormatter()
  private let numberFormatter = NumberFormatter()
  
  private let shadowView = UIView(frame: .zero)
  private let roundCornersView = UIView(frame: .zero)
  private let placeImageView = UIImageView()
  private let placeIconImageView = UIImageView()
  private let placeDescriptionLabel = UILabel()
  private let placeNameLabel = UILabel()
  private let starIconImageView = UIImageView()
  private let starsLabel = UILabel()
  
  init(reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    
    distanceFormatter.unitStyle = .abbreviated
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 1
    numberFormatter.minimumFractionDigits = 1
    
    addSubview(shadowView)
    shadowView.addSubview(roundCornersView)
    roundCornersView.addSubview(placeImageView)
    roundCornersView.addSubview(placeIconImageView)
    roundCornersView.addSubview(placeDescriptionLabel)
    roundCornersView.addSubview(placeNameLabel)
    roundCornersView.addSubview(starIconImageView)
    roundCornersView.addSubview(starsLabel)
    
    shadowView.layer.shadowColor = UIColor.gray.cgColor
    shadowView.layer.shadowOpacity = 0.5
    shadowView.layer.shadowRadius = 5
    shadowView.layer.shadowOffset = .zero
    
    roundCornersView.backgroundColor = .white
    roundCornersView.layer.cornerRadius = 3
    roundCornersView.clipsToBounds = true
    
    placeImageView.contentMode = .scaleAspectFill
    placeImageView.clipsToBounds = true
    
    placeIconImageView.image = UIImage(named: "PlaceTableViewCell.PlaceIcon")?.withRenderingMode(.alwaysTemplate)
    placeIconImageView.tintColor = .gray
    
    placeDescriptionLabel.font = placeDescriptionLabel.font.withSize(10)
    placeDescriptionLabel.textColor = .gray
    
    placeNameLabel.font = placeNameLabel.font.withSize(18)
    
    starIconImageView.image = UIImage(named: "PlaceTableViewCell.StarIcon")?.withRenderingMode(.alwaysTemplate)
    starIconImageView.tintColor = .gray
    
    starsLabel.font = starsLabel.font.withSize(15)
    starsLabel.textColor = .gray
    
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    roundCornersView.translatesAutoresizingMaskIntoConstraints = false
    placeImageView.translatesAutoresizingMaskIntoConstraints = false
    placeIconImageView.translatesAutoresizingMaskIntoConstraints = false
    placeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
    starIconImageView.translatesAutoresizingMaskIntoConstraints = false
    starsLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      shadowView.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
      shadowView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18),
      shadowView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18),
      shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18),
      
      roundCornersView.topAnchor.constraint(equalTo: shadowView.topAnchor),
      roundCornersView.leftAnchor.constraint(equalTo: shadowView.leftAnchor),
      roundCornersView.rightAnchor.constraint(equalTo: shadowView.rightAnchor),
      roundCornersView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
      
      placeImageView.topAnchor.constraint(equalTo: roundCornersView.topAnchor),
      placeImageView.leftAnchor.constraint(equalTo: roundCornersView.leftAnchor),
      placeImageView.rightAnchor.constraint(equalTo: roundCornersView.rightAnchor),
      placeImageView.heightAnchor.constraint(equalToConstant: 150),
      
      placeIconImageView.centerYAnchor.constraint(equalTo: placeDescriptionLabel.centerYAnchor),
      placeIconImageView.leftAnchor.constraint(equalTo: roundCornersView.leftAnchor, constant: 18),
      placeIconImageView.widthAnchor.constraint(equalTo: placeIconImageView.heightAnchor),
      
      placeDescriptionLabel.topAnchor.constraint(equalTo: placeImageView.bottomAnchor, constant: 8),
      placeDescriptionLabel.leftAnchor.constraint(equalTo: placeIconImageView.rightAnchor, constant: 5),
      placeDescriptionLabel.rightAnchor.constraint(equalTo: roundCornersView.rightAnchor, constant: -18),
      
      placeNameLabel.topAnchor.constraint(equalTo: placeDescriptionLabel.bottomAnchor, constant: 8),
      placeNameLabel.leftAnchor.constraint(equalTo: roundCornersView.leftAnchor, constant: 18),
      placeNameLabel.rightAnchor.constraint(equalTo: roundCornersView.rightAnchor, constant: -18),
      
      starIconImageView.centerYAnchor.constraint(equalTo: starsLabel.centerYAnchor),
      starIconImageView.leftAnchor.constraint(equalTo: roundCornersView.leftAnchor, constant: 18),
      starIconImageView.widthAnchor.constraint(equalTo: starIconImageView.heightAnchor),
      
      starsLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 8),
      starsLabel.leftAnchor.constraint(equalTo: starIconImageView.rightAnchor, constant: 5),
      starsLabel.rightAnchor.constraint(equalTo: roundCornersView.rightAnchor, constant: -18),
      starsLabel.bottomAnchor.constraint(equalTo: roundCornersView.bottomAnchor, constant: -15),
    ])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func showPlace(place: Place) {
    placeImageView.kf.setImage(with: URL(string: place.placePhoto))
    
    let distance = distanceFormatter.string(fromDistance: place.distance)
    let category = place.placeCategoryName.uppercased()
    placeDescriptionLabel.text = "\(distance) | \(category)"
    placeNameLabel.text = place.placeName
    
    let starsCount = numberFormatter.string(from: NSNumber(value: place.ratingAvarage))!
    starsLabel.text = starsCount
  }
}
