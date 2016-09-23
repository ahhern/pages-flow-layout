//
//  PagesCollectionViewController.swift
//  AnimationPlayground
//
//  Created by Adrian Hernandez on 9/23/16.
//  Copyright © 2016 Adrian Hernandez. All rights reserved.
//

import Foundation
import UIKit


class PagesCollectionViewController : UICollectionViewController {

    fileprivate var itemInsets : UIEdgeInsets {
        return UIEdgeInsets(top: 60, left: 16, bottom: 60, right: 16)
    }
    fileprivate var itemSize : CGSize {
        let viewSize = self.view.bounds.size
        return CGSize(width: viewSize.width - itemInsets.left - itemInsets.right, height: viewSize.height - itemInsets.bottom - itemInsets.top)
    }
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 16, bottom: 20, right: 16)
    }
    
    init(){
        super.init(collectionViewLayout: PagesFlowLayout())
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: PagesFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension PagesCollectionViewController {
    fileprivate func registerCells(){
        self.collectionView?.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: PageCollectionViewCell.identifier)
    }
}


//MARK: - Delegate
extension PagesCollectionViewController {
    
}


//MARK: - Datasource
extension PagesCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.identifier, for: indexPath)
        
        return cell
    }
}

extension PagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return
//    }
    
    
}



class PageCollectionViewCell : UICollectionViewCell {
    
    static let identifier = "PageCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10.0
    }
}





