//
//  PantsLoginViewController.swift
//  Trousers
//
//  Created by Boris Bügling on 27/08/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import UIKit

class PantsLoginViewController: UIViewController, UITextFieldDelegate {
    var domainTextField : UITextField?
    var passwordTextField : UITextField?

    func buildLabel() -> UILabel {
        var label = UILabel(frame: insetRect(self.view.width()))
        label.font = UIFont(name: "Marion", size: 20)
        label.frame.size.height = 20
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.lightGrayColor()
        return label
    }

    func buildTextField(after: UILabel) -> UITextField {
        var textField = UITextField(frame: after.nextVerticalRect())
        textField.delegate = self
        textField.font = after.font
        textField.placeholder = after.text
        return textField
    }

    func loginTapped(sender : UIButton!) -> Void {
        SSKeychain.setPassword(self.passwordTextField!.text,
            forService: PantsDomainKey, account: self.domainTextField!.text)

        PantsSessionManager.sharedManager.login(self.passwordTextField!.text,
            handler: { (response, error) -> (Void) in
                self.navigationController.pushViewController(PantsPostsViewController(),
                    animated: true)
        })
    }

    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = NSLocalizedString("#pants Login", comment: "")
        self.view.backgroundColor = UIColor.whiteColor()

        var domainLabel = self.buildLabel()
        domainLabel.frame.origin.y = 100
        domainLabel.text = NSLocalizedString("Domain", comment: "")
        self.view.addSubview(domainLabel)

        self.domainTextField = self.buildTextField(domainLabel)
        self.domainTextField!.returnKeyType = UIReturnKeyType.Next
        self.view.addSubview(self.domainTextField!)

        var passwordLabel = self.buildLabel()
        passwordLabel.frame.origin.y = CGRectGetMaxY(self.domainTextField!.frame) + 10
        passwordLabel.text = NSLocalizedString("Password", comment: "")
        self.view.addSubview(passwordLabel)

        self.passwordTextField = self.buildTextField(passwordLabel)
        self.passwordTextField!.returnKeyType = UIReturnKeyType.Go
        self.passwordTextField!.secureTextEntry = true
        self.view.addSubview(self.passwordTextField!)

        var loginButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        loginButton.addTarget(self, action: "loginTapped:",
            forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.backgroundColor = buttonColor()
        loginButton.titleLabel.font = domainLabel.font
        loginButton.frame = self.passwordTextField!.nextVerticalRect()
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        loginButton.setTitle(NSLocalizedString("Login", comment: ""),
            forState: UIControlState.Normal)
        loginButton.frame.size = CGSize(width: 150.0, height: 44.0)
        loginButton.frame.origin.x = (self.view.width() - loginButton.width()) / 2
        self.view.addSubview(loginButton)
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if (textField.returnKeyType == UIReturnKeyType.Next) {
            self.passwordTextField!.becomeFirstResponder()
        } else {
            self.loginTapped(nil)
        }

        return false
    }

}
