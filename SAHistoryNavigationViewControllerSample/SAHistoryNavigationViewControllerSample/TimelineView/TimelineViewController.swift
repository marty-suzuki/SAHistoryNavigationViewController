//
//  TimelineViewController.swift
//  SAHistoryNavigationViewControllerSample
//
//  Created by 鈴木大貴 on 2015/04/01.
//  Copyright (c) 2015年 &#37428;&#26408;&#22823;&#36020;. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let kCellIdentifier = "Cell"
    
    private var contents: [TimelineContent] = [
        TimelineContent(username: "Alex", text: "This is SAHistoryNavigationViewController."),
        TimelineContent(username: "Brian", text: "It has history jump function."),
        TimelineContent(username: "Cassy", text: "If you want to launch history viewer,"),
        TimelineContent(username: "Dave", text: "please tap longer \"<Back\" of Navigation Bar."),
        TimelineContent(username: "Elithabeth", text: "You can see ViewController history"),
        TimelineContent(username: "Alex", text: "as horizonal scroll view."),
        TimelineContent(username: "Brian", text: "If you select one of history,"),
        TimelineContent(username: "Cassy", text: "go back to that ViewController."),
        TimelineContent(username: "Dave", text: "Thanks for trying this sample."),
        TimelineContent(username: "Elithabeth", text: "by skz-atmosphere")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Timeline"
        
        let nib = UINib(nibName: "TimelineViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: kCellIdentifier)
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct TimelineContent {
        var username: String
        var text: String
    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        if let cell = cell as? TimelineViewCell {
            let num = indexPath.row % 5 + 1
            if let image = UIImage(named: "icon_\(num)") {
                cell.setImage(image)
            }
            
            let content = contents[indexPath.row]
            cell.setUsername(content.username)
            cell.setMainText(content.text)
        }
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TimelineViewCell {
                viewController.iconImage = cell.iconImageView?.image
            }
            
            let content = contents[indexPath.row]
            viewController.username = content.username
            viewController.text = content.text
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}