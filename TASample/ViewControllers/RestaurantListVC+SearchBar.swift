//
//  RestaurantListVC+SearchBar.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 18/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import UIKit

extension RestaurantListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
              searchText != "" else {
          viewModel.filteredSections = nil
          tableView.reloadData()
          return
        }
        filterContentForSearchText(searchText)
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Start typing.."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        var filteredSections = [RestaurantSectionType]()
        viewModel.sections.value.forEach { (section) in
            switch section {
            case .favorites(_, let items):
                let filteredItems = items.filter({ $0.name.containsIgnoringCase(searchText) })
                guard !items.isEmpty else { break }
                filteredSections.append(RestaurantSectionType.favorites(title: "Favourites", items: filteredItems))
            case .restaurants(let items):
                let filteredItems = items.filter({ $0.name.containsIgnoringCase(searchText) })
                guard !items.isEmpty else { break }
                filteredSections.append(RestaurantSectionType.restaurants(items: filteredItems))
            }
        }
        viewModel.filteredSections = filteredSections
        tableView.reloadData()
    }
}
