//
//  RestaurantCell.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 16/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    static let id = "RestaurantCell"
    static let nibName = "RestaurantCell"
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var statusOpen: UILabel!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var currentSortLabel: UILabel!
    
    var favouriteButtonHandler: ((UIButton) -> Void)?
    var item: RestaurantCellViewModel? {
        didSet {
            guard let item = item else { return }
            nameLabel.text = item.name
            statusOpen.text = item.currentOpeningState.rawValue
            statusOpen.textColor = item.currentOpeningState.color
            currentSortLabel.text = item.currentSortingText
            favouriteButton.layer.opacity = item.isFavourite ? 1.0 : 0.25
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        favouriteButton.addTarget(self, action: #selector(handleFavouriteButton(_:)), for: .touchUpInside)
    }
    
    @objc func handleFavouriteButton(_ sender: UIButton) {
       favouriteButtonHandler?(sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
