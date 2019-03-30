//
//  ListViewController.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 4/8/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit
import CoreLocation

var cur_weather = "Sunny"
var cur_city = "Champaign"
class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate  {
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var diaryCollection: UICollectionView!
    var key = ""
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(Diaries.count)
        return Diaries.count
    }
    /*
     set up the collection view in the listview of the app.
 */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //fill each cell
        let cell = diaryCollection.dequeueReusableCell(withReuseIdentifier: "diarycell", for: indexPath) as? CollectionViewCell
        cell?.layer.borderWidth = 2.0
        cell?.layer.cornerRadius = 5.0
        cell?.layer.borderColor = UIColor.darkGray.cgColor
        cell?.diary_date.text! = Diaries[indexPath.row].Date
        if(Diaries[indexPath.row].locked){
            cell?.diary_text.text! = "locked"
        }
        else{
            cell?.diary_text.text! = Diaries[indexPath.row].Diary
        }
        
        return cell!
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.transition(with: self.diaryCollection, duration: 1.0, options: .transitionCrossDissolve, animations: {self.diaryCollection.alpha = 1.0}, completion: nil)
    }
    
    /*
     when the a cell in the collection view is selected, it goes to the read diary with all the information in diary objects have
 */
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let mainStroyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVc = mainStroyBoard.instantiateViewController(withIdentifier: "readDiaryViewController") as! readDiaryViewController
        let authVc = mainStroyBoard.instantiateViewController(withIdentifier: "authViewController") as! authViewController
        destVc.dairytext = Diaries[indexPath.row].Diary
        destVc.dairydate = Diaries[indexPath.row].Date
        destVc.id = Diaries[indexPath.row].path
        destVc.music = Diaries[indexPath.row].music
        destVc.city_t = Diaries[indexPath.row].city
        destVc.weather_t = Diaries[indexPath.row].weather
        destVc.font_t = Diaries[indexPath.row].font
        
        authVc.dairytext = Diaries[indexPath.row].Diary
        authVc.dairydate = Diaries[indexPath.row].Date
        authVc.id = Diaries[indexPath.row].path
        authVc.music = Diaries[indexPath.row].music
        authVc.city = Diaries[indexPath.row].city
        authVc.weather = Diaries[indexPath.row].weather
        authVc.font_t = Diaries[indexPath.row].font
        
        if(Diaries[indexPath.row].locked){
            //auth page
            self.navigationController?.pushViewController(authVc, animated: true)
        }
        else{
            self.navigationController?.pushViewController(destVc, animated: true)
        }
    }
    
    /*
     sign out button
 */
    
    @IBAction func signout(_ sender: UIBarButtonItem) {
        self.f_signout()
        self.performSegue(withIdentifier: "logout", sender: self)
    }
    
    override func viewDidLoad() {
        diaryCollection.delegate = self
        diaryCollection.dataSource = self
        self.diaryCollection.alpha = 0.0
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
//        getKey()
//        while(self.key == ""){
//            continue
//        }
//
//        getWeather(key :self.key)
        
                //self.diaryCollection.register(CollectionViewCell.self, forCellWithReuseIdentifier:"CollectionViewCell")
        
        
        // Do any additional setup after loading the view.
    }
    
    /*
     @params : it gets the key from the location key in the api.
     get the key of current location that user is in.
 */
    
    func getWeather(key: String){
        // create the request
        let part_url = "http://dataservice.accuweather.com/currentconditions/v1/"+key
        let second_part = ""
        let str_url = part_url + second_part
        print(str_url)
        let url = URL(string: str_url)!
        let request = URLRequest(url: url)
        print(url)
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let responseData = data,
                error == nil,
                let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) else {
                    print("no notification")
                    return
            }
            if let dictionary = jsonObject as? [Any]{
                let inner_dict = dictionary[0] as! [String:Any]
                print(inner_dict)
                let weather = inner_dict["WeatherText"] as! String
                cur_weather = weather
                
            }
            
        }
        task.resume()
    }
    //IGhFmvmDrTJnpPlg6PGQHjnGupv4z5Gk
    //ctk0jBfGAIWSsAtXEJzamQYYAFQGmVdk
    
    /*
     get the location key of the user's current location
 */
    func getKey(){
        // create the request
        let part_url = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey="+lat_and_long
        let url = URL(string: part_url)!
        let request = URLRequest(url: url)
        print(url)
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let responseData = data,
                error == nil,
                let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) else {
                    print("no notification")
                    return
            }
            //print(jsonObject)
            if let dictionary = jsonObject as? [String:Any]{
                self.key = dictionary["Key"] as! String
                let area = dictionary["SupplementalAdminAreas"] as! [Any]
                let city_ele = area[0] as! [String:Any]
                let city = city_ele["EnglishName"]
                cur_city = city as! String
                //notifi_arr.append(notifi(reason_: dictionary["reason"] as! String))
                
            }
            
        }
        task.resume()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func f_signout(){
        print("in signout")
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }


}
