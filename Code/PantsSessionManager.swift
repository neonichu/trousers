//
//  PantsSessionManager.swift
//  Trousers
//
//  Created by Boris Bügling on 13/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import Foundation

typealias PostsHandler = (posts : Array<PantsPost>!, error: NSError!) -> (Void)

class PantsSessionManager : AFHTTPSessionManager {

    class var sharedManager : PantsSessionManager {
        struct Static {
            static let instance : PantsSessionManager = PantsSessionManager()
        }
        return Static.instance
    }

    override init() {
        super.init(baseURL: NSURL.URLWithString("http://hmans.io/"), sessionConfiguration: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
