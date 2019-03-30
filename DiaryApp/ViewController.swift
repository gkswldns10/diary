//
//  ViewController.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 4/7/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import UserNotifications

let login = FBSDKLoginButton()
var cleanEmail = ""
class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var ref: DatabaseReference?
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("completed login")
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        let email = fetchProfile()
        //getFirebase(credential_: credential)
        print("email before putuser" + email)
        self.performSegue(withIdentifier: "afterlogin", sender: self)
    }
    
    func putUser(email_ : String){
        let path = "userInfo/" + email_
        print("email = " + email_)
        let ref = Database.database().reference(withPath: path)
        
        ref.observe(.value) { (snapshot) in
            
            let registered: Bool = snapshot.exists()
            
            if(registered){
                // do nothing
                return
            }
            else{
                ref.setValue(email_)
            }
        }
       
    }
    
    func getFirebase(credential_: AuthCredential){
        
        Auth.auth().signIn(with: credential_) { (user, error) in
            if let error = error {
                print("error!!")
                return
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    let login: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    

    @IBOutlet weak var logo_image: UIImageView!
    //@IBOutlet weak var login: UIButton!
    @IBOutlet weak var background: UIImageView!
    override func viewDidAppear(_ animated: Bool) {
        if(FBSDKAccessToken.current() != nil){
            self.performSegue(withIdentifier: "nologin", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scheduleLocal()
        if(FBSDKAccessToken.current() != nil){
            let email = fetchProfile()
            cleanEmail = email.replacingOccurrences(of: ".", with: ",")
            
        }
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "background.jpeg")
        self.view.addSubview(imageView)
        self.view.addSubview(login)
        login.delegate = self
        
        
        self.view.bringSubview(toFront: login)        // Do any additional setup after loading the view, typically from a nib.
        login.center.x = self.view.center.x
        login.center.y = 3*(self.view.center.y/2)
        
        self.view.addSubview(logo_image)
        self.view.bringSubview(toFront: logo_image)
        logo_image.center.x = self.view.center.x
        logo_image.center.y = (self.view.center.y/2)
        
    }
    
    func fetchProfile() -> String{
        
        let parameters = ["fields" : "email, first_name"]
        var email = " "
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start{ (connection, result, error) -> Void in
            if (error != nil){
                print("error")
                return
            }
            let info = result as! NSDictionary
            email = info["email"] as! String
            cleanEmail = email.replacingOccurrences(of: ".", with: ",")
           
            self.putUser(email_: cleanEmail)
    }
    return email as! String
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func scheduleLocal() {
        print("Inside Scehdule")
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Did you write Diary?"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default()
        
        var dateComponents = DateComponents()
        dateComponents.hour = 16
        dateComponents.minute = 35
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }


}

