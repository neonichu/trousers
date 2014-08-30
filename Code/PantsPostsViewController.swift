//
//  PantsPostsViewController.swift
//  Trousers
//
//  Created by Boris Bügling on 13/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import UIKit

class PantsPostsViewController: UITableViewController {

    var posts : Array<PantsPost>!

    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.title = "such #pants"
        self.tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: NSStringFromClass(self.dynamicType))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        PantsSessionManager.sharedManager.network(
            { (posts : Array<PantsPost>!, error : NSError!) -> Void in
                self.posts = posts
                self.tableView.reloadData()
            });
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return (self.posts != nil) ? self.posts.count : 0
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(self.dynamicType),
            forIndexPath: indexPath) as UITableViewCell
        var post = self.posts[indexPath.row]

        cell.textLabel.text = post.title

        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)  {
        var vc = PantsPostViewController(post: self.posts[indexPath.row])
        self.navigationController.pushViewController(vc, animated: true)
    }
}
