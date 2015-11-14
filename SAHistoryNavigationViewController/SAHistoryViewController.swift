//
//  SAHistoryViewController.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2015/03/26.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit
import MisterFusion

protocol SAHistoryViewControllerDelegate: class {
    func historyViewController(viewController: SAHistoryViewController, didSelectIndex index: Int)
}

class SAHistoryViewController: UIViewController {
    private let kLineSpace: CGFloat = 20.0
    
    weak var contentView: UIView?
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    var images: [UIImage]?
    var currentIndex: Int = 0
    weak var delegate: SAHistoryViewControllerDelegate?
    
    private var selectedIndex: Int?
    private var isFirstLayoutSubviews = true
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    deinit {
        contentView?.removeFromSuperview()
        contentView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let contentView = contentView {
            view.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            view.addLayoutConstraints(
                contentView.Top,
                contentView.Bottom,
                contentView.Left,
                contentView.Right
            )
        }
        view.backgroundColor = contentView?.backgroundColor
        
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
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addLayoutConstraints(
            collectionView.Top,
            collectionView.Bottom,
            collectionView.CenterX,
            collectionView.Width |==| view.Width |*| 3
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLayoutSubviews {
            scrollToIndex(currentIndex, animated: false)
            isFirstLayoutSubviews = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func scrollToIndex(index: Int, animated: Bool) {
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: animated)
    }
    
    func scrollToSelectedIndex(animated: Bool) {
        guard let index = selectedIndex else {
            return
        }
        scrollToIndex(index, animated: animated)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
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
        let index = indexPath.row
        selectedIndex = index
        delegate?.historyViewController(self, didSelectIndex:index)
    }
}