//
//  coverViewController.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 5/1/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit

class coverViewController: UIViewController {

    @IBOutlet weak var cover_text: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cover_text.backgroundColor = UIColor.clear
        self.cover_text.text = cover
        self.cover_text.alpha = 0.0
        self.cover_text.font = UIFont(name :"Trebuchet MS", size :30)
        self.cover_text.center = view.center
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.transition(with: self.cover_text, duration: 1.0, options: .transitionCrossDissolve, animations: {self.cover_text.alpha = 1.0}, completion: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
