//
//  GalleryCollectionViewCell+FavoriteIcon.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/22/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import Foundation

extension GalleryCollectionViewCell {
    enum FavoriteIconState {
        case normal
        case readyToDelete
    }
    
    /// Set the initial state of the of the favorite icon.
    func setFavoriteIconState(_ state: FavoriteIconState) {
        // customize how the favorite icon is displayed
        favoriteIcon.image = favoriteIcon.image?.withRenderingMode(.alwaysTemplate)
        favoriteIcon.tintColor = iconColor
        
        switch state {
        case .normal: favoriteIcon.image = favoriteFilled
        case .readyToDelete: favoriteIcon.image = favoriteOutline
        }
    }
    
    /// Set the visible state of the favorite icon.
    func setFavoriteIconVisibility(_ visibility: Bool) {
        switch visibility {
        case false: favoriteIcon.isHidden = true
        case true: favoriteIcon.isHidden = false
        }
    }
    
    /// Toggles the favorite icon between a solid and outlined heart.
    func toggleFavoriteIcon() {
        switch favoriteIcon.image {
        case favoriteFilled: favoriteIcon.image = favoriteOutline
        case favoriteOutline: favoriteIcon.image = favoriteFilled
        default: break
        }
    }
}
