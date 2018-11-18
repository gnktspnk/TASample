//
//  RestaurantCellViewModel.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 16/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import UIKit

enum CurrentOpeningState: String {
    case open = "open"
    case closed = "closed"
    case orderAhead = "order ahead"
    
    var color: UIColor {
        switch self {
        case .open: return UIColor.green
        case .closed: return UIColor.red
        case .orderAhead: return UIColor.orange
        }
    }
    
    var sortingPriority: Int {
        switch self {
        case .open: return 0
        case .orderAhead: return 1
        case .closed: return 2
        }
    }
}

struct RestaurantCellSortingValues {
    var bestMatch: Float
    var newest: Float
    var ratingAverage: Double
    var distance: Double
    var popularity: Float
    var averageProductPrice: Int
    var deliveryCosts: Int
    var minCost: Int
}

class RestaurantCellViewModel {
    
    var isFavourite: Bool = false
    var name: String
    var currentOpeningState: CurrentOpeningState
    var currentSortingText: String?
    var sortingType: SortingType? {
        didSet {
            guard let type = sortingType else { return }
            switch type {
            case .bestMatch:
                currentSortingText = "Best match: \(sortingValues.bestMatch)"
            case .newest:
                currentSortingText = "Newest: \(sortingValues.newest)"
            case .ratingAverage:
                currentSortingText =  "Rating Average: \(sortingValues.ratingAverage)"
            case .distance:
                currentSortingText = "Distance: \(sortingValues.distance)"
            case .popularity:
                currentSortingText = "Popularity: \(sortingValues.popularity)"
            case .averageProductPrice:
                currentSortingText = "Average Product Price: \(sortingValues.averageProductPrice)"
            case .deliveryCosts:
                currentSortingText = "Delivery Costs: \(sortingValues.deliveryCosts)"
            case .minCost:
                currentSortingText = "Minimal Cost: \(sortingValues.minCost)"
            }
        }
    }
    private (set) var sortingValues: RestaurantCellSortingValues
    init?(dataModel: RestaurantDataModel) {
        guard let name = dataModel.name,
            let openingState = dataModel.status,
            let sortingValues = dataModel.sortingValues else { return nil }
        self.name = name
        self.currentOpeningState = CurrentOpeningState(rawValue: openingState) ?? .closed
        self.sortingValues = RestaurantCellSortingValues(bestMatch: sortingValues.bestMatch,
                                           newest: sortingValues.newest,
                                           ratingAverage: sortingValues.ratingAverage,
                                           distance: sortingValues.distance,
                                           popularity: sortingValues.popularity,
                                           averageProductPrice: sortingValues.averageProductPrice,
                                           deliveryCosts: sortingValues.deliveryCosts,
                                           minCost: sortingValues.minCost)
    }
    // Additionally, to be able to display data right away from the storage 
    init?(coreDataModel: CDRestaurant) {
        self.isFavourite = true
        guard let name = coreDataModel.name,
              let openingState = coreDataModel.status,
              let sortingValues = coreDataModel.sortingValues else { return nil }
        self.name = name
        self.currentOpeningState = CurrentOpeningState(rawValue: openingState) ?? .closed
        self.sortingValues = RestaurantCellSortingValues(bestMatch: sortingValues.bestMatch,
                                           newest: sortingValues.newest,
                                           ratingAverage: sortingValues.ratingAverage,
                                           distance: sortingValues.distance,
                                           popularity: sortingValues.popularity,
                                           averageProductPrice: Int(sortingValues.averageProductPrice),
                                           deliveryCosts: Int(sortingValues.deliveryCosts),
                                           minCost: Int(sortingValues.minCost))
    }
}
