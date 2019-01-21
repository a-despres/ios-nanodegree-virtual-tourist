//
//  DownloadStatusView+ClassMethods.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/21/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

// MARK: - Class Methods
extension DownloadStatusView {
    func hide() {
        setVisible(false, animated: true)
    }
    
    func show() {
        setVisible(true, animated: true)
    }
    
    func setLocationName(_ name: String?) {
        location.text = name
    }
    
    func start() {
        setStatus(.on, animated: true)
    }
    
    func stop() {
        setStatus(.off, animated: true)
    }
    
    func toggleStatus() {
        switch isVisible {
        case true: hide()
        case false: show()
        }
    }
    
    func updateCount(_ count: Int) {
        status.text = StatusString.downloading(count, totalPhotos).stringValue
    }
    
    // MARK: - Private Methods
    private func setStatus(_ status: Status, animated: Bool) {
        switch status {
        case .on:
            self.activityIndicator.startAnimating()
            self.button.backgroundColor = buttonOnColor
            self.button.setImage(inactiveButtonIcon, for: .disabled)
            self.button.isEnabled = false
            self.buttonWidthConstraint.constant = button.frame.height
            self.locationVerticalConstraint.constant = -8
            self.isActive = true
            self.status.text = StatusString.preparing.stringValue
            self.status.alpha = 1
            self.statusVerticalConstraint.constant = 8
            
        case .off:
            self.activityIndicator.stopAnimating()
            self.button.backgroundColor = buttonOffColor
            self.button.setImage(activeButtonIcon, for: .normal)
            self.button.isEnabled = true
            self.buttonWidthConstraint.constant = activeButtonWidth
            self.locationVerticalConstraint.constant = 0
            self.isActive = false
            self.status.alpha = 0
            self.statusVerticalConstraint.constant = 16
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) { self.contentView.layoutIfNeeded() }
        }
    }
    
    private func setVisible(_ visible: Bool, animated: Bool) {
        let duration = animated ? 0.3 : 0
        
        UIView.animate(withDuration: duration) {
            switch visible {
            case false:
                self.isVisible = false
                self.frame.origin.y += 96
                self.alpha = 0
            case true:
                self.isVisible = true
                self.frame.origin.y -= 96
                self.alpha = 1
            }
            
            self.layoutIfNeeded()
        }
    }
}
