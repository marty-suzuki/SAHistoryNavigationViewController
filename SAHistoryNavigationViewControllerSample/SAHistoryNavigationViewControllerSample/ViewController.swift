//
//  ViewController.swift
//  SAHistoryNavigationViewControllerSample
//
//  Created by 鈴木大貴 on 2015/03/26.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    var number: Int  = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let count = navigationController?.viewControllers.count {
            numberLabel.text = "\(count)"
            switch count % 3 {
            case 0:
                view.backgroundColor = .whiteColor()
            case 1:
                view.backgroundColor = .lightGrayColor()
            default:
                view.backgroundColor = .greenColor()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func didTapNextButton(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as? ViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

