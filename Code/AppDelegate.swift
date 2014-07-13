//
//  AppDelegate.swift
//  Trousers
//
//  Created by Boris Bügling on 13/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.rootViewController = UINavigationController(rootViewController: PantsPostsViewController())
        self.window!.makeKeyAndVisible()

        return true
    }

}
