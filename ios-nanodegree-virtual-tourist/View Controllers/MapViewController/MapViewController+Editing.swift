//
//  MapViewController+Editing.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/8/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

// MARK: - Editing
extension MapViewController {
    
    /// Manages the UI to depict the current editing state.
    func toggleEditingState() {
        isEditingMap = !isEditingMap
        updateEditButtonTitle()
        toggleInstructionsView(animated: true)
    }
    
    /**
     Sets the visibility of the Instructions View.
     - parameter animated: Determines whether or not the change in position is animated.
     */
    func toggleInstructionsView(animated: Bool) {
        switch isEditingMap {
        case false: instructionsVerticalConstraint.constant += instructionsView.frame.height
        case true: instructionsVerticalConstraint.constant -= instructionsView.frame.height
        }
        
        if animated {
            UIView.animate(withDuration: 0.15) { self.view.layoutIfNeeded() }
        }
    }
    
    /// Sets the title text of the Edit Button based on the current editing state.
    func updateEditButtonTitle() {
        switch isEditingMap {
        case false: editButton.title = "Edit"
        case true: editButton.title = "Done"
        }
    }
}
