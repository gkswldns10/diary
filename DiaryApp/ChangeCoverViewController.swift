//
//  ChangeCoverViewController.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 5/1/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit
import FirebaseDatabase

/*
 Extension that handles the hide keyboard. 
 */

extension UIViewController {
    func hideKeyboardWhenTappedAround1() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard1() {
        view.endEditing(true)
    }
}


class ChangeCoverViewController: UIViewController {

    @IBOutlet weak var new_cover_text: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        new_cover_text.backgroundColor = UIColor.clear
        new_cover_text.font = UIFont(name :"Trebuchet MS", size :30)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     saves the cover script into firebase.
 */

    @IBAction func save(){
        let path = "userInfo/" + cleanEmail
        let ref = Database.database().reference(withPath: path)
        let diary = ref.child("cover")
        let new_cover = new_cover_text.text
        diary.setValue(new_cover)
        self.performSegue(withIdentifier: "aftercoversaving", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
