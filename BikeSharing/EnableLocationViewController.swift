//
//  EnableLocationViewController.swift
//  BikeSharing
//
//  Created by Vishal Bharam on 9/30/17.
//  Copyright © 2017 BikeSharing. All rights reserved.
//

import UIKit

public class EnableLocationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!


    let steps: [(desc: String, image: UIImage?)] = [
        (desc: "Open up the 'Settings' app.", image: #imageLiteral(resourceName: "Settings")),
        (desc: "Navigate to Privacy > Location Services > BikeSharing! and select 'When in Use'.", image: #imageLiteral(resourceName: "EnableLocation")),
        (desc: "You're done! Restart the app to start making the world a greener place.", image: #imageLiteral(resourceName: "Check"))
    ]

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let transparentView = UIView()
        transparentView.backgroundColor = .clear
        self.collectionView.backgroundView = transparentView
        self.collectionView.backgroundColor = .clear
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.pageController.numberOfPages = self.steps.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return steps.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "demo", for: indexPath) as! EnableLocationCell
        cell.picture.image = steps[indexPath.row].image
        cell.explanation.text = steps[indexPath.row].desc
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        self.pageController.currentPage = page
    }
}
