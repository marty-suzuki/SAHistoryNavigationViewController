//
//  SAHistoryViewController.swift
//  SAHistoryNavigationViewControllerSample
//
//  Created by 鈴木大貴 on 2015/03/26.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

protocol SAHistoryViewControllerDelegate: class {
    func didSelectIndex(index: Int)
}

class SAHistoryViewController: UIViewController {

    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var images: [UIImage]?
    var currentIndex: Int = 0
    
    weak var delegate: SAHistoryViewControllerDelegate?
    
    private let kLineSpace: CGFloat = 20.0
    
    override init() {
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let size = UIScreen.mainScreen().bounds.size
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = size
            layout.minimumInteritemSpacing = 0.0
            layout.minimumLineSpacing = 20.0
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: size.width, bottom: 0.0, right: size.width)
            layout.scrollDirection = .Horizontal
        }
        
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clearColor()
        collectionView.showsHorizontalScrollIndicator = false
        
        NSLayoutConstraint.applyAutoLayout(view, target: collectionView, index: nil, top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, height: nil, width: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        collectionView.reloadData()
        scrollToIndex(currentIndex, animated: false)
    }
    
    func scrollToIndex(index: Int, animated: Bool) {
        let width = UIScreen.mainScreen().bounds.size.width
        collectionView.setContentOffset(CGPoint(x: (width + kLineSpace) * CGFloat(index), y: 0), animated: animated)
    }
}

extension SAHistoryViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = images?.count {
            return count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        
        for view in cell.subviews {
            if let view = view as? UIImageView {
                view.removeFromSuperview()
            }
        }
    
        let imageView = UIImageView(frame: cell.bounds)
        imageView.image = images?[indexPath.row]
        cell.addSubview(imageView)
        
        return cell
    }
}

extension SAHistoryViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        delegate?.didSelectIndex(indexPath.row)
    }
}