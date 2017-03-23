//
//  LoaddingIndicator.swift
//  Runner
//
//  Created by Khanh Pham on 3/23/17.
//  Copyright © 2017 Khanh Pham. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoadingIndicator {
    
    private var process = 0
    
    init() {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    }
    
    func show() {
        process = process + 1
        SVProgressHUD.show()
    }
    
    func dismiss() {
        SVProgressHUD.dismiss()
        process = process - 1
    }
}
