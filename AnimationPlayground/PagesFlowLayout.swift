//
//  PagesFlowLayout.swift
//  AnimationPlayground
//
//  Created by Adrian Hernandez on 9/23/16.
//  Copyright © 2016 Adrian Hernandez. All rights reserved.
//

import Foundation
import UIKit


class PagesFlowLayout : UICollectionViewFlowLayout {
    
    fileprivate enum ScrollDirectionType {
        case left, right, undefined
    }
    
    fileprivate var itemInsets : UIEdgeInsets {
        return UIEdgeInsets(top: 60, left: 16, bottom: 60, right: 16)
    }
    fileprivate var customItemSize : CGSize {
        let viewSize = self.collectionView!.bounds.size
        return CGSize(width: viewSize.width - itemInsets.left - itemInsets.right, height: viewSize.height - itemInsets.bottom - itemInsets.top)
    }
    
    fileprivate var scrollDirectionType : ScrollDirectionType {
        let delta = self.collectionView!.contentOffset.x - self.lastKnownOffset.x
        guard delta != 0 else { return .undefined }
        return delta < 0 ? .left : .right
    }
    
    fileprivate var layoutInformation : [NSObject : AnyObject] = [:]
    fileprivate var lastKnownOffset : CGPoint = CGPoint(x: 0, y: 0)
    
    fileprivate var currentIndex : Int {
        let width = self.itemSize.width + self.minimumLineSpacing
        let currentOffset = self.collectionView!.contentOffset.x
        return Int(currentOffset/width)
    }
    

    
    
}



extension PagesFlowLayout {

    override func prepare() {
        super.prepare()
        
        self.itemSize = customItemSize
        self.minimumLineSpacing = UIScreen.main.bounds.size.width
//        self.collectionView?.isPagingEnabled = true
        self.scrollDirection = .horizontal
        
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print(#function + "\(rect)")
        
        
        let attributes : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
        
        
        for attr in attributes {
            if rect.intersects(attr.frame) {
                print(attr.frame)
                attr.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4)/2)
            }
        }
        
        return attributes//super.layoutAttributesForElements(in: rect)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print(#function)
        return super.layoutAttributesForItem(at: indexPath)
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}






