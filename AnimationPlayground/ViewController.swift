//
//  ViewController.swift
//  AnimationPlayground
//
//  Created by Adrian Hernandez on 9/23/16.
//  Copyright © 2016 Adrian Hernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //add a replicator layer
        let r = CAReplicatorLayer()
        
        r.frame = view.bounds
        view.layer.addSublayer(r)
        
        //make a simple dot layer
        let dot = CALayer()
        dot.bounds = CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0)
        dot.position = CGPoint(x: 18.0, y: view.center.y)
        dot.backgroundColor = UIColor.green.cgColor
        dot.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        dot.borderWidth = 1.0
        dot.cornerRadius = dot.frame.height/2
        
        r.addSublayer(dot)
        
        
        r.instanceCount = 16
        r.instanceDelay = 0.1
        r.instanceGreenOffset = 10
        r.instanceRedOffset  = 10
        
        r.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat(M_PI_2)))
        
        CATransaction.begin()
        
        
        let animation_1 = CABasicAnimation(keyPath: "instanceTransform")
        animation_1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation_1.duration     = 1.0
        
        animation_1.fromValue    = NSValue(caTransform3D: CATransform3DIdentity)
        animation_1.toValue      = NSValue(caTransform3D: CATransform3DMakeTranslation(20.0, 0.0, 0.0))
        
        animation_1.isRemovedOnCompletion = false
        animation_1.fillMode = kCAFillModeForwards
        r.add(animation_1, forKey: "key")
        
//        let r_rotation = CABasicAnimation(keyPath: "transform.rotation.z")
//        r_rotation.fromValue = 0.0
//        r_rotation.toValue = 2*M_PI
//        r_rotation.repeatCount = Float.infinity
//        r_rotation.duration = 2.0
//        r.add(r_rotation, forKey: "rotation")
        
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.duration     = 1.0
        animation.repeatCount  = Float.infinity
        animation.autoreverses = true
        animation.fromValue    = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue      = NSValue(caTransform3D: CATransform3DMakeScale(1.4, 10, 1.0))
        dot.add(animation, forKey: "key")
        
        
        CATransaction.commit()
        
    }


    @IBAction func showPages(_ sender: AnyObject) {
        self.navigationController?.pushViewController(PagesCollectionViewController(), animated: true)
    }
}







