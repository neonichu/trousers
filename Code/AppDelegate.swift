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

        var accounts = SSKeychain.accountsForService(PantsDomainKey)
        if (accounts.count == 0) {
            self.window!.rootViewController = UINavigationController(rootViewController:PantsLoginViewController())
        } else {
            self.window!.rootViewController = UIViewController()

            var account = accounts[0]["acct"] as String
            var password = SSKeychain.passwordForService(PantsDomainKey, account: account)
            PantsSessionManager.sharedManager.login(password,
                handler: { (response, error) -> (Void) in
                    if (error != nil) {
                        UIAlertView.showAlertWithError(error)

                        
                        return
                    }

                    self.window!.rootViewController = UINavigationController(rootViewController: PantsPostsViewController())
            })
        }

        self.window!.makeKeyAndVisible()

        return true
    }

}
