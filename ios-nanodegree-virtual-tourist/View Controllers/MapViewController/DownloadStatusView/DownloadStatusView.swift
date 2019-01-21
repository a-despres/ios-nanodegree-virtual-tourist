//
//  DownloadStatusView.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/21/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

/// A View displaying the status of a current download.
@IBDesignable
class DownloadStatusView: UIView {
    // MARK: Delegate
    var delegate: DownloadStatusViewDelegate?
    
    // MARK: - Properties
    private let xibName = "DownloadStatusView"
    let activeButtonWidth: CGFloat = 112
    
    private var colorOn: UIColor = UIColor.blue
    private var colorOff: UIColor = UIColor.lightGray
    
    var iconActive: UIImage = UIImage()
    var iconInactive: UIImage = UIImage()
    
    var isActive: Bool = true
    var isVisible: Bool = true
    
    var totalPhotos: Int = 0
    
    enum Status {
        case on, off
    }
    
    enum StatusString {
        case preparing
        case downloading(Int, Int)
        
        var stringValue: String {
            switch self {
            case .preparing: return "Retrieving Gallery Information"
            case .downloading(let current, let total): return "\(current) of \(total) Photos Downloaded"
            }
        }
    }
    
    // MARK: - IBInspectable Properties
    @IBInspectable var buttonOffColor: UIColor {
        get { return colorOff }
        set { colorOff = newValue }
    }
    @IBInspectable var buttonOnColor: UIColor {
        get { return colorOn }
        set { colorOn = newValue }
    }
    
    @IBInspectable var activeButtonIcon: UIImage {
        get { return iconActive }
        set { iconActive = newValue }
    }
    @IBInspectable var inactiveButtonIcon: UIImage {
        get { return iconInactive }
        set { iconInactive = newValue }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            // set corner radius of view
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            
            // set corner radius of button
            button.layer.cornerRadius = newValue - 4
            button.layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var defaultText: String {
        get { return status.text! }
        set { status.text = newValue }
    }

    // MARK: - IBOutlets
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var locationVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusVerticalConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.buttonPressed()
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: DownloadStatusView.self)
        bundle.loadNibNamed(xibName, owner: self, options: nil)
        contentView.setupXibInView(self)
    }
}

extension UIView {
    func setupXibInView(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = view.frame
        view.addSubview(self)
        
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
