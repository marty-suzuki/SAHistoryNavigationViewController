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
    
    fileprivate let kCellIdentifier = "Cell"
    
    fileprivate var contents: [TimelineContent] = [
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
        tableView.register(nib, forCellReuseIdentifier: kCellIdentifier)
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
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

  @IBAction func segueBack(_ segue: UIStoryboardSegue) {}
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)!
        
        if let cell = cell as? TimelineViewCell {
            let num = (indexPath as NSIndexPath).row % 5 + 1
            if let image = UIImage(named: "icon_\(num)") {
                cell.setIconImage(image)
            }
            
            let content = contents[(indexPath as NSIndexPath).row]
            cell.setUsername(content.username)
            cell.setMainText(content.text)
        }
        
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            if let cell = tableView.cellForRow(at: indexPath) as? TimelineViewCell {
                viewController.iconImage = cell.iconImageView?.image
            }
            
            let content = contents[(indexPath as NSIndexPath).row]
            viewController.username = content.username
            viewController.text = content.text
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
