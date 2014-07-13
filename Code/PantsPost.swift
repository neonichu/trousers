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
    var url : NSURL?

    class func postFromJSON(JSON : [String:AnyObject]) -> PantsPost {
        let mapper = Mapper<PantsPost>()

        mapper.map { (field, object) in
            field["body"] => object.bodyAsMarkdown
            field["body_html"] => object.bodyAsHtml
            field["domain"] => object.domain
            field["guid"] => object.identifier
        }

        var post = mapper.parse(JSON, to: PantsPost());

        var publishedAt : AnyObject? = JSON["published_at"]
        post.publicationDate = ISO8601DateFormatter().dateFromString(publishedAt as String)

        var tags : AnyObject? = JSON["tags"]
        post.tags = tags as Array<String>?

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
