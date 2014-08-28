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

    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge.None
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
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if (textField.returnKeyType == UIReturnKeyType.Next) {
            self.passwordTextField!.becomeFirstResponder()
        } else {
            PantsDomainSet("http://" + self.domainTextField!.text)
            PantsSessionManager.sharedManager.login(self.passwordTextField!.text,
                handler: { (response, error) -> (Void) in
                    self.navigationController.pushViewController(PantsPostsViewController(),
                        animated: true)
            })
        }

        return false
    }

}
