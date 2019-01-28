//
//  UIViewController+Extension.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/27/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Display a UIAlertView for the given error.
     - parameter error: The error to be parsed and displayed.
     */
    func displayAlertForError(_ error: Error) {
        if presentedViewController == nil {
            present(ErrorAlert.forError(error), animated: true, completion: nil)
        }
    }
}
