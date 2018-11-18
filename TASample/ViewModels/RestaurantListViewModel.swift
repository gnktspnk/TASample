//
//  RestaurantListViewModel.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 16/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import UIKit
import CoreData

enum RestaurantSectionType {
    case favorites(title: String, items: [RestaurantCellViewModel])
    case restaurants(items: [RestaurantCellViewModel])
    
    var items: [RestaurantCellViewModel] {
        switch self {
        case .favorites(title: _, items: let items ):
            return items
        case .restaurants(items: let items):
            return items
        }
    }
}

enum NetworkStatus {
    case idle
    case loading
    case success
    case error
    case empty
}

class RestaurantListViewModel: NSObject, UITableViewDataSource, Movable {
    
    let defaultSortingType: SortingType = .bestMatch
    var networkStatus = Variable<NetworkStatus>.init(.idle)
    
    // Movable protocol properties
    var sections = Variable.init([RestaurantSectionType]())
    var filteredSections : [RestaurantSectionType]?
    
    /* The property is updated every time button handler from the cell triggers
       By capturing an IndexPath I am able to operate with viewModels, update table view
    */
    var currentFavouriteCandidate: IndexPath?
    
    
    /* Notifies VC there is a request for destructive action, passes restaurant name to it
    */
    var deletionFavouriteRequest = Variable.init("")
    
    /*
       Response for desctructive action from VC
    */
    var shouldDeleteFavouriteCandidate: Bool = false {
        didSet {
            if shouldDeleteFavouriteCandidate {
                deleteFavorite()
            }
        }
    }
    
    /* Data Models from Network Request
     */
    var dataModels: [RestaurantDataModel]?
    
    /* Current Sorting type is passed by handler of UIAlertAction, from VC
     */
    var currentSortingType: SortingType? {
        didSet {
            guard let newSortingType = currentSortingType else { return }
            applySortingType(newSortingType)
        }
    }
    /* Core Data models for favourite restaurants
    */
    var favouriteRestaurants: [CDRestaurant] = []
    
    override init() {
        super.init()
        if let restaurants =  CoreDataManager.shared.fetchAllFavouritesFromStorage() {
            self.favouriteRestaurants = restaurants
            let restVms = favouriteRestaurants.compactMap { RestaurantCellViewModel(coreDataModel: $0) }
            sections.value.append(RestaurantSectionType.favorites(title: "Favourites", items: restVms))
        }
        updateRestaurants()
    }
    
    func updateRestaurants() {
        networkStatus.value = .loading
        NetworkService.getUsersRestaurants { [ weak self ] (isSuccess, dataModel) in
            if isSuccess {
                guard let restaurantsDataModels = dataModel?.restaurants else {
                    self?.networkStatus.value = .empty
                    return
                }
                self?.dataModels = restaurantsDataModels
                var restaurantsVMs = restaurantsDataModels.compactMap({RestaurantCellViewModel(dataModel: $0)})
                //deleting restaurants which exist in favourites
                if let favouritesNames: [String] = self?.favouriteRestaurants.compactMap({$0.name}) {
                    restaurantsVMs = restaurantsVMs.filter({ !favouritesNames.contains($0.name) })
                }
                //TODO: update fav restaurants with fresh properties
                self?.sections.value.append(RestaurantSectionType.restaurants(items: restaurantsVMs))
                self?.currentSortingType = self?.defaultSortingType
                self?.networkStatus.value = .success
            } else {
                self?.networkStatus.value = .error
            }
        }
    }
    
    private func applySortingType(_ sortingType: SortingType?) {
        var sortedSections = [RestaurantSectionType]()
        self.sections.value.forEach { (section) in
            switch section {
            case .favorites(_, let items):
                let sortedItems = items.sort(with: sortingType)
                guard !items.isEmpty else { break }
                sortedSections.append(RestaurantSectionType.favorites(title: "Favourites", items: sortedItems))
            case .restaurants(let items):
                let sortedItems = items.sort(with: sortingType)
                guard !items.isEmpty else { break }
                sortedSections.append(RestaurantSectionType.restaurants(items: sortedItems))
            }
        }
     sections.value = sortedSections
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredSections?.count ?? sections.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSections?[section].items.count ?? sections.value[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = filteredSections ?? self.sections.value
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.id, for: indexPath) as? RestaurantCell,
            sections.count > 0 else { return UITableViewCell() }
        let vm = sections[indexPath.section].items[indexPath.row]
        cell.item = vm
        cell.favouriteButtonHandler = { [ weak self ] button in
            self?.updateFavourite(indexPath: indexPath, isFavourite: vm.isFavourite, name: vm.name)
        }
        return cell
    }
    
    func updateFavourite(indexPath: IndexPath, isFavourite: Bool, name: String) {
        self.currentFavouriteCandidate = indexPath
        if isFavourite {
            deletionFavouriteRequest.value = name
        } else {
            addFavourite()
        }
    }
    
    private func addFavourite() {
        guard let indexPath = currentFavouriteCandidate else { return }
        let row = indexPath.row
        let section = indexPath.section
        
        // highlighting the start in the cell
        let currentRestaurantVM = sections.value[section].items[row]
        currentRestaurantVM.isFavourite = true
        
        if favouriteRestaurants.isEmpty {
            sections.value.insert(.favorites(title: "Favourites", items: []), at: 0)
        }
        // trying to save to core data
        guard let dataModel = self.dataModels?.getRestaurant(by: currentRestaurantVM.name),
              let cdRestaurant = CoreDataManager.shared.save(restaurantDataModel: dataModel) else { return }
        favouriteRestaurants.append(cdRestaurant)
        /* if succeeded moving the view model between sections,
         moveToFavorite(IndexPath:RestaurantCellViewModel:) has default implemetation
        **/
        moveToFavourite(indexPath: indexPath, viewModel: currentRestaurantVM)
        // and applying sort after
        applySortingType(currentSortingType)
    }
    
    private func deleteFavorite() {
        guard let indexPath = currentFavouriteCandidate else { return }
        let row = indexPath.row
        let section = indexPath.section
        
        let currentRestaurantVM = sections.value[section].items[row]
        currentRestaurantVM.isFavourite = false
        
        if let managedObject = self.favouriteRestaurants.filter({ $0.name == currentRestaurantVM.name }).first {
            if CoreDataManager.shared.delete(managedObjectToDelete: managedObject) != nil {
                if let index = favouriteRestaurants.firstIndex(of: managedObject) {
                    favouriteRestaurants.remove(at: index)
                }
            }
        }
        moveFromFavourite(indexPath: indexPath, viewModel: currentRestaurantVM)
        applySortingType(currentSortingType)
    }
    
}

extension RestaurantListViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections.value[section] {
        case .favorites(let title, _):
            return title
        default: return "Restaurants"
        }
    }
}
