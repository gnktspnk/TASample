//
//  SortingType.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 18/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import Foundation

enum SortingType: CaseIterable {
    case bestMatch
    case newest
    case ratingAverage
    case distance
    case popularity
    case averageProductPrice
    case deliveryCosts
    case minCost
    
    var textDescription: String {
        switch self {
        case .bestMatch: return "Best Match"
        case .newest: return "Newest"
        case .ratingAverage: return "Rating Average"
        case .distance: return "Distance"
        case .popularity: return "Popularity"
        case .averageProductPrice: return "Average Product Price"
        case .deliveryCosts: return "Delivery Costs"
        case .minCost: return "Minimal Cost"
        }
    }
    
    var predicate: (RestaurantCellViewModel, RestaurantCellViewModel) -> Bool {
        switch self {
        case .bestMatch: return { return $0.sortingValues.bestMatch < $1.sortingValues.bestMatch }
        case .newest: return { return $0.sortingValues.newest < $1.sortingValues.newest }
        case .ratingAverage: return { return $0.sortingValues.ratingAverage < $1.sortingValues.ratingAverage }
        case .distance: return { return $0.sortingValues.distance < $1.sortingValues.distance }
        case .popularity: return { return $0.sortingValues.popularity < $1.sortingValues.popularity }
        case .averageProductPrice: return { return $0.sortingValues.averageProductPrice < $1.sortingValues.averageProductPrice }
        case .deliveryCosts: return { return $0.sortingValues.deliveryCosts < $1.sortingValues.deliveryCosts }
        case .minCost: return { return $0.sortingValues.minCost < $1.sortingValues.minCost }
        }
    }
}
