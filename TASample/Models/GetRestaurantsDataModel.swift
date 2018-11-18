//
//  GetRestaurantsDataModel.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 16/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import Foundation

struct GetRestaurantsDataModel: Codable {
    let restaurants: [RestaurantDataModel]?
}

struct RestaurantDataModel: Codable {
    let name: String?
    let status: String?
    let sortingValues: RestaurantSortingValuesDataModel?
}

struct RestaurantSortingValuesDataModel: Codable {
    let bestMatch: Float
    let newest: Float
    let ratingAverage: Double
    let distance: Double
    let popularity: Float
    let averageProductPrice: Int
    let deliveryCosts: Int
    let minCost: Int
}


