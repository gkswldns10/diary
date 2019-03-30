//
//  customSegue.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 4/9/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit

class customSegue: UIStoryboardSegue {
    
    override func perform() {
        //face()
    }
    
    func face(){
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalcenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y:0.05)
        toViewController.view.center = originalcenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }) { (success) in
            fromViewController.present(toViewController, animated: false, completion: nil)
        }
    }
}
