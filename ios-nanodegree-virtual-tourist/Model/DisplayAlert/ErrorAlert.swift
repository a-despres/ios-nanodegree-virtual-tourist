//
//  ErrorAlert.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/27/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

struct ErrorAlert {
    private static let dismissAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
    
    static func forError(_ error: Error) -> UIAlertController {
        // Define alert view
        let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        
        // Add error message
        switch error {
        case is ClientError:
            let error = error as! ClientError
            alertController.message = error.message
            
        case is DataError:
            let error = error as! DataError
            alertController.message = error.message
            
        default: alertController.message = error.localizedDescription
        }
        
        // Add dismiss button and return
        alertController.addAction(dismissAction)
        return alertController
    }
}
