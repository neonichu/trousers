//
//  PantsRequestSerializer.swift
//  Trousers
//
//  Created by Boris Bügling on 28/08/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import Foundation

class PantsRequestSerializer: AFHTTPRequestSerializer {
    var token : String

    init(token : String) {
        self.token = token
        
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: This is never called :(
    override func requestWithMethod(method: String!, URLString: String!, parameters: AnyObject!, error: NSErrorPointer) -> NSMutableURLRequest! {
        var parametersDict = parameters as [NSObject:AnyObject]
        return self.multipartFormRequestWithMethod(method, URLString: URLString, parameters: parametersDict, constructingBodyWithBlock: { (data : AFMultipartFormData!) -> Void in
            data.appendPartWithFormData(self.token.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "token");
        }, error: error);
    }
}
