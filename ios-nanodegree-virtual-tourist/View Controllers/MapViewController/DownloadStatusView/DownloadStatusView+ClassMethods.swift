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
    
    // MARK: - Public Class Methods
    
    /**
     A method used to setup the Download Status View to a specified state.
     - parameter state: The state of the view.
     - parameter isVisible: The visibility of the view.
     - parameter isAnimated: Animate the state of the view.
     */
    func view(to state: Status, isVisible: Bool, isAnimated: Bool) {
        setVisible(isVisible, animated: isAnimated)
        setStatus(state, animated: isAnimated)
    }
    
    /**
     Set the location text of the Download Status View.
     - parameter name: The name of the location to display.
     */
    func setLocationName(_ name: String?) {
        location.text = name
    }
    
    /**
     Sets the status the Download Status View.
     - parameter status: The state of the view.
     - parameter animated: The boolean value indicating if changes to the view should animate or display instantly.
     */
    func setStatus(_ status: Status, animated: Bool) {
        switch status {
        case .complete:
            activityIndicator.stopAnimating()
            resetDownloaded()
            setupButton(backgroundColor: enabledColor, icon: enbabledIcon, state: .normal, isEnabled: true, width: enabledWidth)
            setupLocationText(verticalOffset: 0)
            setupStatusText(alpha: 0, verticalOffset: 16)
        
        case .downloading:
            break // nothing special happens at this point
            
        case .preparing:
            activityIndicator.startAnimating()
            setupButton(backgroundColor: disabledColor, icon: disabledIcon, state: .disabled, isEnabled: false, width: button.frame.height)
            setupLocationText(verticalOffset: -8)
            setupStatusText(StatusString.preparing.stringValue, alpha: 1, verticalOffset: 8)
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) { self.contentView.layoutIfNeeded() }
        }
    }
    
    /**
     Set the visibility of the Download Status View.
     - parameter visible: The boolean value indicating if the view is visible or not.
     - parameter animated: The boolean value indicating if the visibility of the view should be animated or instant.
     */
    func setVisible(_ visible: Bool, animated: Bool) {
        let duration = animated ? 0.3 : 0
        
        switch visible {
        case false: UIView.animate(withDuration: duration, animations: hideViewAnimations)
        case true: UIView.animate(withDuration: duration, animations: showViewAnimations)
        }
    }
    
    /// Update the download count value of the status text.
    func updateCount() {
        status.text = StatusString.downloading(downloaded, total).stringValue
    }
    
    // MARK: - Private Class Methods
    
    /**
     Set the appearance of the download status button.
     - parameter color: The color of the button.
     - parameter icon: The icon displayed on the button.
     - parameter state: The control state of the button.
     - parameter isEnabled: The boolean value indicating if the button is enabled or disabled.
     - parameter width: The width of the button.
     */
    private func setupButton(backgroundColor color: UIColor, icon: UIImage, state: UIControl.State, isEnabled: Bool, width: CGFloat) {
        button.backgroundColor = color
        button.setImage(icon, for: state)
        button.isEnabled = isEnabled
        buttonWidthConstraint.constant = width
    }
    
    /**
     Set the appearance of the location text.
     - parameter verticalOffset: The vertical offset of the location text.
     */
    private func setupLocationText(verticalOffset: CGFloat) {
        locationVerticalConstraint.constant = verticalOffset
    }
    
    /**
     Set the appearance of the download status text.
     - parameter text: The text value of the status text. (Optional)
     - parameter alpha: The alpha of the status text.
     - parameter verticalOffset: The vertical offset of the status text.
     */
    private func setupStatusText(_ text: String? = nil, alpha: CGFloat, verticalOffset: CGFloat) {
        if let text = text { status.text = text }
        status.alpha = alpha
        statusVerticalConstraint.constant = verticalOffset
    }
    
    // MARK: - UI Animations
    
    /// Hides the Download Status View by sliding the view down and fading out.
    private func hideViewAnimations() {
        setVisible(false)
        frame.origin.y += 96
        alpha = 0
        layoutIfNeeded()
    }
    
    /// Shows thew Download Status View by sliding the view up and fading in.
    private func showViewAnimations() {
        setVisible(true)
        frame.origin.y -= 96
        alpha = 1
        layoutIfNeeded()
    }
}
