//
//  Movable.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 18/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import Foundation

protocol Movable {
    var sections: Variable<[RestaurantSectionType]> { get set }
    var filteredSections: [RestaurantSectionType]? { get set }
    
    func moveToFavourite(indexPath: IndexPath, viewModel: RestaurantCellViewModel)
    func moveFromFavourite(indexPath: IndexPath, viewModel: RestaurantCellViewModel)
}

extension Movable {
    func moveToFavourite(indexPath: IndexPath, viewModel: RestaurantCellViewModel) {
        let row = indexPath.row

        var newSections = [RestaurantSectionType]()
        sections.value.forEach { (section) in
            switch section {
            case .favorites(_, let items):
                var newItems = items
                newItems.append(viewModel)
                newSections.append(RestaurantSectionType.favorites(title: "Favourites", items: newItems))
            case .restaurants(let items):
                var newItems = items
                newItems.remove(at: row)
                newSections.append(RestaurantSectionType.restaurants(items: newItems))
            }
        }
       sections.value = newSections
    }
    
    func moveFromFavourite(indexPath: IndexPath, viewModel: RestaurantCellViewModel) {
        let row = indexPath.row
   
        var newSections = [RestaurantSectionType]()
        sections.value.forEach { (section) in
            switch section {
            case .favorites(_, let items):
                var newItems = items
                newItems.remove(at: row)
                newSections.append(RestaurantSectionType.favorites(title: "Favourites", items: newItems))
            case .restaurants(let items):
                var newItems = items
                newItems.append(viewModel)
                newSections.append(RestaurantSectionType.restaurants(items: newItems))
            }
        }
        sections.value = newSections
    }
}
