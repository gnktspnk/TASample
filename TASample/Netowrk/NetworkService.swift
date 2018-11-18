//
//  NetworkService.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 16/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import Foundation

struct NetworkService {
    
    static let networkRequestDelay = 2.0
    
    static func getUsersRestaurants(completion: @escaping (Bool, GetRestaurantsDataModel?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + networkRequestDelay) {
            let jsonDecoder = JSONDecoder()
            if let getRestaurantsDataModel = try? jsonDecoder.decode(GetRestaurantsDataModel.self, from: "stub".stubData) {
                completion(true, getRestaurantsDataModel)
            } else {
                completion(false, nil)
            }
        }
    }
}
