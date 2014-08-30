//
//  PantsPost.swift
//  Trousers
//
//  Created by Boris Bügling on 13/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import Foundation

class PantsPost {

    var bodyAsMarkdown : String?
    var bodyAsHtml : String?
    var domain : String?
    var identifier : String?
    var publicationDate : NSDate?
    var tags : Array<String>?
    var title : String?
    var url : NSURL?

    class func postFromJSON(JSON : [String:AnyObject]) -> PantsPost {
        var post = PantsPost()

        var body : AnyObject? = JSON["body"]
        post.bodyAsMarkdown = body as String?

        var body_html : AnyObject? = JSON["body_html"]
        post.bodyAsHtml = body_html as String?

        var domain : AnyObject? = JSON["domain"]
        post.domain = domain as String?

        var guid : AnyObject? = JSON["guid"]
        post.identifier = guid as String?

        var publishedAt : AnyObject? = JSON["published_at"]
        post.publicationDate = ISO8601DateFormatter().dateFromString(publishedAt as String)

        var tags : AnyObject? = JSON["tags"]
        post.tags = tags as Array<String>?

        var title : AnyObject? = JSON["title"];
        post.title = title as String?

        var urlString : AnyObject? = JSON["url"]
        post.url = NSURL(string: urlString as String)

        return post;
    }

    func body() -> NSAttributedString {
        var document = BPParser().parse(self.bodyAsMarkdown)

        var converter = BPAttributedStringConverter()
        converter.displaySettings.quoteFont = UIFont(name: "Marion-Italic",
            size: UIFont.systemFontSize() + 1.0)

        return converter.convertDocument(document)
    }
}
