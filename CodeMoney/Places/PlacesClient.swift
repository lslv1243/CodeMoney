//
//  PlacesAPI.swift
//  CodeMoney
//
//  Created by Leonardo da Silva on 05/08/19.
//  Copyright © 2019 Leonardo da Silva. All rights reserved.
//

import PromiseKit
import Alamofire
import PMKAlamofire

class PlacesClient {
  private let decoder = JSONDecoder()
  
  func listDistance(latitude: Float, longitude: Float, search: String = "", page: Int = 0) -> Promise<[Place]> {
    let url = "https://rest.codemoney.com.br/v2/sale/list-distance?page=\(page)&lat=\(latitude)&lng=\(longitude)&searchString=\(search)"
    return Alamofire.request(url)
      .responseData()
      .map { response -> [Place] in
        return try! self.decoder.decode(Array<Place>.self, from: response.data)
      }
  }
}
