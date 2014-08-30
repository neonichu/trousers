//
//  UIAlertViewExtension.swift
//  Trousers
//
//  Created by Boris Bügling on 30/08/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import UIKit

extension UIAlertView {
    class func showAlertWithError(error : NSError) {
        var alert = UIAlertView(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
        alert.show()
    }
}
