//
//  UIViewGeometry.swift
//  Trousers
//
//  Created by Boris Bügling on 28/08/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import UIKit

func insetRect(width : CGFloat) -> CGRect {
    return CGRectInset(CGRect(x: 0, y: 10, width: width, height: 0), 10, 0)
}

extension UIView {
    func nextVerticalRect() -> CGRect {
        var rect = self.frame
        rect.origin.y = CGRectGetMaxY(self.frame) + 10
        return rect
    }

    func x() -> CGFloat { return self.frame.origin.x }
    func y() -> CGFloat { return self.frame.origin.y }

    func width() -> CGFloat { return self.frame.size.width }
    func height() -> CGFloat { return self.frame.size.height }
}
