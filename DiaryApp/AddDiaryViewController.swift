//
//  AddDiaryViewController.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 4/8/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import AVFoundation
import MediaPlayer

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

var songs : [String] = []
var audioplayer = AVAudioPlayer()
var currentlyPlaying: String = ""
var fonts : [String] = []
var currentFont = ""

class AddDiaryViewController: UIViewController , MPMediaPickerControllerDelegate{

    @IBOutlet weak var lock_btn: UIButton!
    var isclicked = false
    
    @IBOutlet weak var save_btn: UIButton!
    @IBOutlet weak var Change_btn: UIButton!
    @IBOutlet weak var cancel_btn: UIButton!
    @IBOutlet weak var Fonts_btn: UIButton!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var weather_text: UILabel!
    @IBOutlet weak var nowPlaying: UILabel!
    @IBOutlet weak var lock_ind: UILabel!
    
    //@IBOutlet weak var changeSong: UIButton!
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer : MPMusicPlayerController?
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var diaryView: UITextView!
    @IBOutlet weak var dairyField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.text = getDate()
        self.date.alpha = 0.0
        self.diaryView.alpha = 0.0
        self.diaryView.backgroundColor = UIColor.clear
        self.hideKeyboardWhenTappedAround()
        self.lock_ind.text = "unlock"
        self.weather_text.text = cur_weather
        self.weather_text.alpha = 0.0
        self.city.text = cur_city
        self.city.alpha = 0.0
        if(currentFont != ""){
            self.date.font = UIFont(name: currentFont, size: 12)
            self.diaryView.font = UIFont(name: currentFont, size: 12)
            //self.lock_ind.font = UIFont(name: currentFont, size: 12)
            self.weather_text.font = UIFont(name: currentFont, size: 12)
            self.city.font = UIFont(name: currentFont, size: 12)
        }
        
        getFonts()
        
        getSong()
        do {
        audioplayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "K", ofType: "mp3")!))
            audioplayer.prepareToPlay()
        }
        catch{
            print("error!")
        }
        audioplayer.play()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     
     retrieve all the fonts in the system.
 */
    
    func getFonts(){
        fonts = UIFont.familyNames
    }
    
    /*
     get the all the songs from the files inside of the application
 */
    
    func getSong(){
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        songs.removeAll()
        do{
            let songpath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for song in songpath{
                var mySong = song.absoluteString
                if mySong.contains(".mp3"){
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count-1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songs.append(mySong)
                }
            }
        }
        catch{
            
        }
    }
    
    /*
     it handles the animation of the view controller
 */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.transition(with: self.date, duration: 1.0, options: .transitionCrossDissolve, animations: {self.date.alpha = 1.0}, completion: nil)
        UIView.transition(with: self.diaryView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.diaryView.alpha = 1.0}, completion: nil)
        UIView.transition(with: self.weather_text, duration: 1.0, options: .transitionCrossDissolve, animations: {self.weather_text.alpha = 1.0}, completion: nil)
        UIView.transition(with: self.city, duration: 1.0, options: .transitionCrossDissolve, animations: {self.city.alpha = 1.0}, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     it saves the diary into the firebase database and exit the current viewcontroller
 */
    
    @IBAction func saving(){
        print(cleanEmail)
        saveDiary(email_: cleanEmail)
        if(audioplayer.isPlaying){
            audioplayer.stop()
        }
        self.performSegue(withIdentifier: "saving", sender: self)
    }
    
    @IBAction func cancel(){
        if(audioplayer.isPlaying){
            audioplayer.stop()
        }
        self.performSegue(withIdentifier: "cancel", sender: self)
    }
    
    /*
     
     Gets the today's date
 */

    func getDate() -> String{
        let format = DateFormatter()
        format.dateStyle = .long
        let str = format.string(from:Date())
        return str
    }
    /*
     flippers between locking and unlocking a diary.
 */
    @IBAction func clicked(){
        isclicked = !isclicked
        if(isclicked){
        self.lock_ind.text = "lock"
        self.lock_ind.textColor = UIColor.white
        }
        else{
            self.lock_ind.text = "unlock"
            self.lock_ind.textColor = UIColor.white
        }
    }
    
    /*
     actual data saving into the firebase. 
 */
    
    func saveDiary(email_ : String){
        let path = "userInfo/" + email_
        let ref = Database.database().reference(withPath: path)
        let diary = ref.child("diary").childByAutoId()
        let dict = ["diary" : self.diaryView.text, "date" : self.date.text, "locked" : self.isclicked, "music" : currentlyPlaying, "city" : cur_city, "weather" : cur_weather, "font" : currentFont] as [String : Any]
        diary.setValue(dict)
    }
}
