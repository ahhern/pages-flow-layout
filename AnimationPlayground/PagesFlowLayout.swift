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
    
    fileprivate var currentIndex : Int = 0
//    {
//        let width = self.itemSize.width + self.minimumLineSpacing
//        let currentOffset = self.collectionView!.contentOffset.x
//        return Int(currentOffset/width)
//    }
    
    fileprivate var maxIndex : Int {
        return self.collectionView!.numberOfItems(inSection: 0) - 1
    }
    

    
    
}



extension PagesFlowLayout {

    override func prepare() {
        super.prepare()
        self.collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        self.itemSize = customItemSize
        self.minimumLineSpacing = (2/3)*UIScreen.main.bounds.size.width
        self.scrollDirection = .horizontal
        
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let delta = velocity.x < CGFloat(0) ? -1 : 1
        let newIndex = min(self.maxIndex, max(self.currentIndex + delta, 0))
        self.currentIndex = newIndex
        return CGPoint(x: self.makeTargetContentOffsetForItem(atIndex: newIndex), y: proposedContentOffset.y)
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
        
        for attr in attributes {
            let frame = attr.frame
            if rect.intersects(frame) {
                attr.transform = self.getAffineTransformForItem(withAttributes: attr, scrollingDirectionType: self.scrollDirectionType)
            }
        }
        
        self.lastKnownOffset = self.collectionView!.contentOffset
        return attributes//super.layoutAttributesForElements(in: rect)
    }
    

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print(#function)
        guard let attr = super.layoutAttributesForItem(at: indexPath) else { return nil }
        attr.transform = self.getAffineTransformForItem(withAttributes: attr, scrollingDirectionType: self.scrollDirectionType)
        return attr
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}


extension PagesFlowLayout {
    
    fileprivate func makeTargetContentOffsetForItem(atIndex index: Int) -> CGFloat {
        let attr = self.layoutAttributesForItem(at: NSIndexPath(item: index, section: 0) as IndexPath)
        return attr!.center.x - 160
    }
    
    fileprivate func getAffineTransformForItem(withAttributes attributes: UICollectionViewLayoutAttributes, scrollingDirectionType : ScrollDirectionType ) -> CGAffineTransform {
        
        
        let contentOffsetX     = self.collectionView!.contentOffset.x
        let collectionViewSize = self.collectionView!.frame.size
        let visibleRect = CGRect(origin: CGPoint(x: contentOffsetX, y: 0 ), size: collectionViewSize)
        
        let maxAngle = CGFloat(M_PI/18) //36
        let minAngle = -maxAngle
        
        var angle : CGFloat
        let delta = fabs(visibleRect.midX - attributes.frame.midX)
        let maxDistance = collectionViewSize.width/2
        
        
        if delta >= maxDistance {
            angle = scrollingDirectionType == .left ? maxAngle : minAngle
        }
        else {
            let sign : CGFloat = scrollingDirectionType == .left ? 1 : -1
            angle = sign*maxAngle*(delta/maxDistance)
        }
        
        if angle == 0 {
            print("\(delta)")
        }
        
        print(delta)
        
        
        let editingItemIndexPath = attributes.indexPath
        if self.currentIndex == editingItemIndexPath.item {
            //
        }
        
        return CGAffineTransform(rotationAngle: angle)
    }
}








