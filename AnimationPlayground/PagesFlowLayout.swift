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
    
    /// Returns the default margins to use for the section.
    fileprivate let defaultSectionInsets : UIEdgeInsets = UIEdgeInsets(top: 30, left: 16, bottom: 20, right: 16)
    
    /// Returns the default item size.
    fileprivate var defaultItemSize : CGSize {
        let viewSize = self.collectionView!.bounds.size
        return CGSize(width: viewSize.width - defaultSectionInsets.left - defaultSectionInsets.right, height: viewSize.height - defaultSectionInsets.bottom - defaultSectionInsets.top)
    }
    
    /// Returns `ScrollDirectionType.left`, `ScrollDirectionType.right` or `ScrollDirectionType.undefined` if the user is 
    /// scrolling left, right or not scrolling respectively.
    fileprivate var scrollDirectionType : ScrollDirectionType {
        let delta = self.collectionView!.contentOffset.x - self.lastKnownOffset.x
        guard delta != 0 else { return .undefined }
        return delta < 0 ? .left : .right
    }
    
    /// Keeps track of the collection view last content offset.
    fileprivate var lastKnownOffset : CGPoint = CGPoint(x: 0, y: 0)
    
    /// Keeps track of the index of the visible item when user is not scrolling.
    fileprivate var currentIndex : Int = 0
    
    /// Maximum index of an item in the collection.
    fileprivate var maxIndex : Int {
        return self.collectionView!.numberOfItems(inSection: self.collectionView!.numberOfSections - 1) - 1
    }
    
    /// Default space between items in the same row.
    fileprivate var defaultLineSpacing : CGFloat {
        return (2/3)*self.collectionView!.frame.size.width
    }
    
    /// Minimum scrolling velocity needed to scroll to next/previous item.
    fileprivate let minScrollingVelocity : CGFloat = 0.5
    
    /// Maximum value for the absolute value of the item's rotation angle.
    fileprivate let maxAngle : CGFloat = CGFloat(M_PI/18)
    
    /// Maximum value for items offset from center during animation.
    fileprivate let maxOffsetY : CGFloat = 10
    
}

//MARK: - Overrides
extension PagesFlowLayout {

    override func prepare() {
        super.prepare()
        self.collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        self.itemSize = self.defaultItemSize
        self.sectionInset = self.defaultSectionInsets
        self.minimumLineSpacing = self.defaultLineSpacing
        self.scrollDirection = .horizontal
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        // if the velocity is less than the `minScrollingVelocity` stay in current item. Otherwise we go to previous/next
        // item depending on scrolling direction.
        let delta = fabs(velocity.x) >= self.minScrollingVelocity ? (velocity.x < CGFloat(0) ? -1 : 1) : 0
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
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attr = super.layoutAttributesForItem(at: indexPath) else { return nil }
        attr.transform = self.getAffineTransformForItem(withAttributes: attr, scrollingDirectionType: self.scrollDirectionType)
        return attr
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}


//MARK: - Helper functions.
extension PagesFlowLayout {
    
    /// Returns `x` content offset necessary to center the item at `index` on screen.
    fileprivate func makeTargetContentOffsetForItem(atIndex index: Int) -> CGFloat {
        let attr = self.layoutAttributesForItem(at: NSIndexPath(item: index, section: 0) as IndexPath)
        return attr!.center.x - self.collectionView!.frame.size.width/2
    }
    
    /// Returns an affine transform to use for the item with specified attributes.
    fileprivate func getAffineTransformForItem(withAttributes attributes: UICollectionViewLayoutAttributes, scrollingDirectionType : ScrollDirectionType ) -> CGAffineTransform {
        
        // convenience constants.
        let contentOffsetX     = self.collectionView!.contentOffset.x
        let collectionViewSize = self.collectionView!.frame.size
        let visibleRect = CGRect(origin: CGPoint(x: contentOffsetX, y: 0 ), size: collectionViewSize)
        
        let maxOffsetY = self.maxOffsetY
        let maxAngle = self.maxAngle
        let rotationAngleDirection : CGFloat = scrollingDirectionType == .left ? 1 : -1

        let distanceFromCenter = fabs(visibleRect.midX - attributes.frame.midX)
        let maxDistance = collectionViewSize.width/2
        
        // rotation angle to apply to the transform.
        let rotationAngle = distanceFromCenter >= maxDistance ? rotationAngleDirection*maxAngle : rotationAngleDirection*maxAngle*(distanceFromCenter/maxDistance)
        
        // y translation to apply to the transform.
        let translationY = distanceFromCenter <= maxDistance/2 ? maxOffsetY*((2*distanceFromCenter)/maxDistance) : maxOffsetY*(maxDistance/(2*distanceFromCenter))
        
        
        return CGAffineTransform(rotationAngle: rotationAngle).translatedBy(x: 0, y: translationY)
    }
}




