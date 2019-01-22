//
//  DownloadStatusView+Protocol.swift
//  ios-nanodegree-virtual-tourist
//
//  Created by Andrew Despres on 1/21/19.
//  Copyright © 2019 Andrew Despres. All rights reserved.
//

import UIKit

protocol DownloadStatusViewDelegate {
    func downloadStatusView(_ downloadStatusView: DownloadStatusView, buttonTapped button: UIButton)
}
