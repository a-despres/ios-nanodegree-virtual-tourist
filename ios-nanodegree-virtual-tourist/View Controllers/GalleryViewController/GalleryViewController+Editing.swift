//
//  GalleryViewController+Editing.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Steve Ross on 1/19/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

// MARK: Gallery View Controller - Editing
extension GalleryViewController {
    
    /// Manages the UI to depict the current editing state.
    func toggleEditingState() {
        isEditingGallery = !isEditingGallery
        photosToDelete = [Photo]()
        updateEditButtonTitle()
        toggleEditPane(animated: true)
        collectionView.reloadData()
    }
    
    /**
     Sets the visibility of the Instructions View.
     - parameter animated: Determines whether or not the change in position is animated.
     */
    func toggleEditPane(animated: Bool) {
        switch isEditingGallery {
        case false: editPaneVerticalConstraint.constant -= editPane.frame.height
        case true: editPaneVerticalConstraint.constant += editPane.frame.height
        }
        
        toggleUpdateButton()
        
        if animated {
            UIView.animate(withDuration: 0.15) { self.view.layoutIfNeeded() }
        }
    }
    
    /// Toggles the enabled state of the update button.
    func toggleUpdateButton() {
        switch photosToDelete.count {
        case 0: updateButton.isEnabled = false
        default: updateButton.isEnabled = true
        }
    }
    
    /// Sets the title text of the Edit Button based on the current editing state.
    func updateEditButtonTitle() {
        switch isEditingGallery {
        case false: editButton.title = "Edit"
        case true: editButton.title = "Done"
        }
    }
    
    /// Toggles the visibility of the button found in the `EmptyGalleryView`.
    func toggleEmptyViewButton() {
        switch isEditingGallery {
        case false: emptyView.button.isHidden = false
        case true: emptyView.button.isHidden = true
        }
    }
}
