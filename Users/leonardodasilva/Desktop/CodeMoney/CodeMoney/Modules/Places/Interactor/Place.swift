//
//  Place.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 05/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import Foundation

struct Place: Codable {
  let distance: Double
  let placeCityLongitude: Float
  let placeCityName: String
  let placeCityStateAbbrev: String
  let admin: Bool
  let placeStreet: String
  let placeCityStateName: String
  let placeCityLatitude: Float
  let placePhoto: String
  let photo: String
  let placeName: String
  let placeLocal: String
  let phoneNumber: String
  let email: String
  let latitude: Float
  let longitude: Float
  let address: String
  let placeDescription: String
  let id: String
  let blocked: Bool
  let salePromotion: Int
  let promotion: Int
  let totalPromotion: Int
  let placeCategoryName: String
  let placeCategoryId: Int
  let ratingAvarage: Float
  let appear: Bool
}
