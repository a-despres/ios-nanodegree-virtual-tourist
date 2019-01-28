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
    
    // MARK: - Constants
    private let xibName = "DownloadStatusView"
    
    // MARK: - Public Properties
    public private(set) var downloaded: Int = 0
    public private(set) var isDownloading: Bool = false
    public private(set) var isVisible: Bool = true
    public private(set) var total: Int = 36
    
    // MARK: - Private Properties
    private var colorDisabled: UIColor = UIColor.lightGray
    private var colorEnabled: UIColor = UIColor.blue
    private var colorError: UIColor = UIColor.red
    
    private var iconDisabled: UIImage = UIImage()
    private var iconEnabled: UIImage = UIImage()
    
    private var widthDisabled: CGFloat = 56
    private var widthEnabled: CGFloat = 112
    
    // MARK: - IBInspectable Properties
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
    
    @IBInspectable var disabledColor: UIColor {
        get { return colorDisabled }
        set { colorDisabled = newValue }
    }
    
    @IBInspectable var disabledIcon: UIImage {
        get { return iconDisabled }
        set { iconDisabled = newValue }
    }
    
    @IBInspectable var disabledWidth: CGFloat {
        get { return widthDisabled }
        set { widthDisabled = newValue }
    }
    
    @IBInspectable var enabledColor: UIColor {
        get { return colorEnabled }
        set { colorEnabled = newValue }
    }
    
    @IBInspectable var enabledIcon: UIImage {
        get { return iconEnabled }
        set { iconEnabled = newValue }
    }
    
    @IBInspectable var enabledWidth: CGFloat {
        get { return widthEnabled }
        set { widthEnabled = newValue }
    }
    
    @IBInspectable var errorColor: UIColor {
        get { return colorError }
        set { colorError = newValue }
    }

    // MARK: - IBOutlets
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var locationVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusVerticalConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.downloadStatusView(self, buttonTapped: sender)
    }
    
    @IBAction func viewSwiped(_ sender: UISwipeGestureRecognizer) {
        if !isDownloading {
            setVisible(false, animated: true)
        }
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
    
    // MARK: - Property Setters
    
    /// Sets the number of photos downloading by incrementing the value by 1.
    func incrementDownloaded() {
        downloaded += 1
        updateCount()
    }
    
    /// Resets the number of photos downloaded to 0.
    func resetDownloaded() {
        downloaded = 0
        updateCount()
    }
    
    /**
     Set the downloading status for the view.
     - parameter downloading: The boolean value indicating if data currently being downloaded.
     */
    func setDownloading(_ downloading: Bool) {
        self.isDownloading = downloading
        delegate?.downloadStatusView(self, isDownloading: downloading)
    }
    
    /**
     Set the total number of photos to be downloaded.
     - parameter total: The total number of photos to be downloaded.
     */
    func setTotal(_ total: Int) {
        self.total = total
    }
    
    /**
     Set the visibility of the view.
     - parameter visibile: The boolean value indicating where or not the view should be visible.
     */
    func setVisible(_ visible: Bool) {
        isVisible = visible
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
