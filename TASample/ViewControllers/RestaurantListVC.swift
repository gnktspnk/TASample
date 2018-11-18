//
//  RestaurantListVC.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 16/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import UIKit

class RestaurantListVC: UIViewController {
    static let nibName = "RestaurantListVC"
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var sortBarButtonItem: UIBarButtonItem?
    var sortingView: UIAlertController?
    
    var viewModel = RestaurantListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupSortingView()
        setupTableView()
        setupSearchBar()
        subscribeToViewModel()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: RestaurantCell.nibName, bundle: nil), forCellReuseIdentifier: RestaurantCell.id)
        tableView.dataSource = viewModel
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Restaurants"
        navigationController?.navigationBar.prefersLargeTitles = true
        let buttonTitle = "Sort"
        sortBarButtonItem = UIBarButtonItem(title: buttonTitle,
                                            style: .plain, target: self,
                                            action: #selector(openSortingController))
        navigationItem.setRightBarButton(sortBarButtonItem, animated: true)
    }
    
    private func setupSortingView() {
        sortingView = UIAlertController(title: nil,
                                             message: nil,
                                             preferredStyle: .actionSheet)
        
        SortingType.allCases.forEach { (type) in
            let sortingAction = UIAlertAction(title: type.textDescription,
                                              style: .default,
                                              handler: { [weak self] _ in
                                                self?.sortBarButtonItem?.title = "\(type.textDescription) ✏️"
                                                self?.viewModel.currentSortingType = type })
            sortingView?.addAction(sortingAction)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (ok) in
            print("cancel")
        }
        sortingView?.addAction(cancel)
    }
    
    private func subscribeToViewModel() {
        viewModel.networkStatus.subscribe(listener: { [weak self] networkStatus in
            switch networkStatus {
            case .loading:
                self?.spinner.isHidden = false
                self?.spinner.startAnimating()
            default:
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
            }
        })
        viewModel.sections.subscribe { [weak self] sections in
            self?.tableView.reloadData()
            if let sortingTitle = self?.viewModel.currentSortingType?.textDescription {
                self?.sortBarButtonItem?.title = "\(sortingTitle) ✏️"
            }
            
        }
        viewModel.deletionFavouriteRequest.subscribe { [weak self] restName in
            guard restName != "" else { return }
            let handleFavouriteView = UIAlertController(title: "Remove \(restName) from your favourites list?",
                message: "The restaurant will be also delted from the storage.",
                preferredStyle:  .actionSheet)
            let confirmAction = UIAlertAction(title: "Remove",
                                              style: .destructive,
                                              handler: { [weak self] _ in
                                              self?.viewModel.shouldDeleteFavouriteCandidate = true
            })
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel,
                                             handler: { _ in print("action canceled")})
            
            handleFavouriteView.addAction(confirmAction)
            handleFavouriteView.addAction(cancelAction)
            self?.present(handleFavouriteView, animated: true, completion: nil)
        }
    }
    
    @objc func openSortingController() {
        guard let sortingAlertView = sortingView else { return }
        present(sortingAlertView, animated: true) {
            print("opened")
        }
    }

}
