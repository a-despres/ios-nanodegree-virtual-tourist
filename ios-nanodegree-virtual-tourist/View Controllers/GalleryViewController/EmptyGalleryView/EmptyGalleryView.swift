//
//  EmptyGalleryView.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/27/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

class EmptyGalleryView: UIView {
    // MARK: - Delegate
    var delegate: EmptyGalleryViewDelegate?

    // MARK: - Constants
    private let xibName = "EmptyGalleryView"
    
    // MARK: - IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    // MARK: - IBActions
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.emptyGalleryView(self, buttonTapped: sender)
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
        
        // setup image
        image.image = image.image?.withRenderingMode(.alwaysTemplate)
        image.tintColor = UIColor(red: 206/255, green: 214/255, blue: 224/255, alpha: 1)
        
        // setup button
        button.layer.cornerRadius = 8
    }
}
