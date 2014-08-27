//
//  PantsPostViewController.swift
//  Trousers
//
//  Created by Boris Bügling on 13/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import WebKit
import UIKit

class PantsPostViewController: UIViewController {

    var post : PantsPost?

    init(post: PantsPost) {
        super.init(nibName: nil, bundle: nil)

        self.post = post
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        var webView = WKWebView(frame: self.view.bounds)
        webView.loadHTMLString(self.post?.bodyAsHtml, baseURL: self.post?.url)

        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(webView)
    }

    /*override func viewDidAppear(animated: Bool) {
        (self.view.subviews[0] as WKWebView).scrollView.zoomScale = 1.0
    }*/
}
