//
//  PantsSessionManager.swift
//  Trousers
//
//  Created by Boris Bügling on 13/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import Foundation

let PantsDomainKey = "PantsDomain"

func PantsDomain() -> String? {
    return NSUserDefaults.standardUserDefaults().valueForKey(PantsDomainKey) as? String
}

func PantsDomainSet(domain : String) -> Void {
    NSUserDefaults.standardUserDefaults().setValue(domain, forKey: PantsDomainKey)
}

typealias LoginHandler = (response: AnyObject!, error: NSError!) -> (Void)
typealias PostsHandler = (posts : Array<PantsPost>!, error: NSError!) -> (Void)

class PantsSessionManager : AFHTTPSessionManager {

    class var sharedManager : PantsSessionManager {
        struct Static {
            static let baseURL = NSURL.URLWithString(PantsDomain()!)
            static let instance : PantsSessionManager = PantsSessionManager(baseURL: baseURL)
        }
        return Static.instance
    }

    override init(baseURL url: NSURL!) {
        super.init(baseURL: url, sessionConfiguration: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func login(password : String, handler: LoginHandler) -> Void {
        self.POST("login.json",
            parameters: nil,
            constructingBodyWithBlock: { (data : AFMultipartFormData!) -> Void in
                data.appendPartWithFormData(password.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), name: "login[password]")
            }, success: { (dataTask : NSURLSessionDataTask!,
                responseObject : AnyObject!) -> Void in
                var token : AnyObject? = (responseObject as [String:AnyObject])["token"]
                self.requestSerializer = PantsRequestSerializer(token: token as String)

                handler(response: responseObject, error: nil)
            }, failure: { (dataTask: NSURLSessionDataTask!, error: NSError!) -> Void in
                handler(response: nil, error: error)
        })
    }

    func posts(handler : PostsHandler) -> Void {
        self.GET("posts.json",
            parameters: nil,
            success: { (dataTask : NSURLSessionDataTask!, responseObject : AnyObject!) -> Void in
                var posts = Array<PantsPost>()

                for postDictionary in responseObject! as NSArray {
                    posts.append(PantsPost.postFromJSON(postDictionary as [String:AnyObject]))
                }

                handler(posts: posts, error: nil);
            },
            failure: { (dataTask : NSURLSessionDataTask!, error : NSError!) -> Void in
                handler(posts: nil, error: error)
            })
    }
}
