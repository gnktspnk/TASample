//
//  Array.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 17/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import Foundation

extension Array where Element == RestaurantDataModel {
    
    func getRestaurant(by name: String) -> RestaurantDataModel? {
        return self.filter({ $0.name == name }).first
    }
    
}

extension Array where Element == RestaurantCellViewModel {
    
    func sort(with sortingType: SortingType?) -> [RestaurantCellViewModel] {
        self.forEach { (rest) in
            rest.sortingType = sortingType
        }
        return self.sorted(by: { (rest1, rest2) -> Bool in
            if rest1.isFavourite != rest2.isFavourite {
                return rest1.isFavourite
            } else if rest1.currentOpeningState.sortingPriority != rest2.currentOpeningState.sortingPriority  {
                return rest1.currentOpeningState.sortingPriority < rest2.currentOpeningState.sortingPriority
            } else if let type = sortingType {
                return type.predicate(rest1, rest2)
            } else {
                return true
            }
        })
    }
    
}
