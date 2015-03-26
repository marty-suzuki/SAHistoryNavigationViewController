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
        numberLabel.text = "\(number)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func didTapNextButton(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewControllerWithIdentifier("ViewContoller") as? ViewController {
            viewController.number = ++number
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func didTapRightBarButton(sender: UIBarButtonItem) {
        navigationController?.showHistory()
    }
}

