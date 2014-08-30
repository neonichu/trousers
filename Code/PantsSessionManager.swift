//
//  PantsSessionManager.swift
//  Trousers
//
//  Created by Boris Bügling on 13/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import Foundation

let PantsDomainKey = "PantsDomain"

typealias LoginHandler = (response: AnyObject!, error: NSError!) -> (Void)
typealias PostsHandler = (posts : Array<PantsPost>!, error: NSError!) -> (Void)

class PantsSessionManager : AFHTTPSessionManager {
    var token : String?

    class var sharedManager : PantsSessionManager {
        struct Static {
            static let domain = SSKeychain.accountsForService(PantsDomainKey)[0]["acct"] as String
            static let baseURL = NSURL.URLWithString("http://" + domain)
            static let instance : PantsSessionManager = PantsSessionManager(baseURL: baseURL)
        }
        return Static.instance
    }

    override func GET(URLString: String!, parameters: AnyObject!,
        success: ((NSURLSessionDataTask!, AnyObject!) -> Void)!,
        failure: ((NSURLSessionDataTask!, NSError!) -> Void)!) -> NSURLSessionDataTask! {
            var parametersDict = [:]

            if (parameters != nil) {
                parametersDict = parameters as [String:AnyObject]
            }

            var url = NSURL(string: URLString, relativeToURL: self.baseURL).absoluteString
            var request = self.requestSerializer.multipartFormRequestWithMethod("GET", URLString: url, parameters: parametersDict, constructingBodyWithBlock: { (data : AFMultipartFormData!) -> Void in
                data.appendPartWithFormData(self.token!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "token")
                }, error: nil)

            var task : NSURLSessionDataTask!
            task = self.dataTaskWithRequest(request, completionHandler: { (response: NSURLResponse!, responseObject : AnyObject!, error : NSError!) -> Void in
                if (error != nil) {
                    if (failure != nil) {
                        failure(task, error);
                    }
                } else {
                    if (success != nil) {
                        success(task, responseObject);
                    }
                }

            })
            
            task.resume()
            
            return task
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
                self.token = token as? String

                handler(response: responseObject, error: nil)
            }, failure: { (dataTask: NSURLSessionDataTask!, error: NSError!) -> Void in
                handler(response: nil, error: error)
        })
    }

    func network(handler : PostsHandler) -> Void {
        self.posts("network.json", handler: handler)
    }

    func posts(handler : PostsHandler) -> Void {
        self.posts("posts.json", handler: handler)
    }

    func posts(URLString : String, handler : PostsHandler) -> Void {
        self.GET(URLString,
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
