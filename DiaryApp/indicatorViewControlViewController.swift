//
//  indicatorViewControlViewController.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 4/17/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit
import CoreLocation

class Diary{
    var Date: String = ""
    var Diary: String = ""
    var path: String = ""
    var locked:Bool = false
    var music:String = ""
    var city:String = ""
    var weather:String = ""
    var font: String = ""
}
var Diaries = [Diary]()
var lat_and_long = ""
var cover = ""
class indicatorViewControlViewController: UIViewController , CLLocationManagerDelegate {
    let locManager = CLLocationManager()
    @IBOutlet weak var redirect: UILabel!
    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locManager.requestAlwaysAuthorization()
        
        self.locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(indicator)
        self.view.addSubview(redirect)
        self.view.bringSubview(toFront: redirect)
        }
    override func viewDidAppear(_ animated: Bool) {
        //self.performSegue(withIdentifier: "afterloading", sender: self )
        indicator.startAnimating()
        self.getCover(email_: cleanEmail)
        self.getData(email_: cleanEmail)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            //UIApplication.shared.endIgnoringInteractionEvents()
            self.indicator.stopAnimating()
            self.performSegue(withIdentifier: "afterloading", sender: self )
        }
        
    }
    
    /*
     from the location manager it gets the lat and long position of the user.
*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat_and_long = "\(locValue.latitude),\(locValue.longitude)"
    }
    
    func getCover(email_: String){
        let path = "userInfo/" + cleanEmail
        let ref = Database.database().reference(withPath: path)
        ref.observe(.value, with: {(snap: DataSnapshot) in
            let snapshotDictionary = snap.value as! [String:AnyObject]
            //print(snapshotDictionary["cover"])
            cover = snapshotDictionary["cover"] as! String
        })
        
    }
    
    /*
     @params: current clean version of the email that used in firebase data retrieval
     
     get the data from firebase with e-mail.
 */
    
    func getData(email_: String){
        Diaries.removeAll()
        let path = "userInfo/" + cleanEmail
        print(path)
        let ref = Database.database().reference(withPath: path)
        let ref2 = ref.child("diary")
        ref2.observe(.value, with: {(snap: DataSnapshot) in
            
            let snapshotDictionnary = snap.value! as? [String: AnyObject]
            for snap in snapshotDictionnary as! [String: AnyObject]{
                let ID = snap.0
                print(ID)
                
                ref2.child(ID).observe(.value, with: {(diaryDict) in
                    if let diaryDictionary = diaryDict.value as? [String:AnyObject]{
                        let date = diaryDictionary["date"] as! String
                        print(date)
                        let dia = Diary()
                        dia.Date = date
                        let diary = diaryDictionary["diary"] as! String
                        dia.Diary = diary
                        dia.path = ID
                        let lock = diaryDictionary["locked"] as! Bool
                        dia.locked = lock
                        let music = diaryDictionary["music"] as! String
                        dia.music = music
                        let city = diaryDictionary["city"] as! String
                        dia.city = city
                        let weather = diaryDictionary["weather"] as! String
                        dia.weather = weather
                        let font = diaryDictionary["font"] as! String
                        dia.font = font
                        Diaries.append(dia)
                    }
                })
                
                //dia.Date = snapshotDictionnary![ID]?.child("date") as! String
            }
            //print(snapshotDictionnary![key]!["date"] as! String)
            
        })
    }
        // Do any additional setup after loading the view.
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

