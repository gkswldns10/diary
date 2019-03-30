//
//  readDiaryViewController.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 4/9/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit
import FirebaseDatabase
import AVFoundation
class readDiaryViewController: UIViewController {

    @IBOutlet weak var back_button: UIButton!
    
    @IBOutlet weak var cur_music: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var diary: UITextView!
    
    @IBOutlet weak var weather: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    var dairytext = ""
    var dairydate = ""
    var id = ""
    var music = ""
    var city_t = ""
    var weather_t = ""
    var font_t = "" 
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.diary.alpha = 1.0
        self.date.alpha = 0.0
        self.diary.alpha = 0.0
        self.weather.alpha = 0.0
        self.city.alpha = 0.0
        self.diary.text = dairytext
        self.date.text = dairydate
        self.city.text = city_t
        self.weather.text = weather_t
        self.date.textAlignment = .center
        self.diary.backgroundColor = UIColor.clear
        self.cur_music?.text = "song name : " + music
        
        if(self.font_t != ""){
            self.date.font = UIFont(name: self.font_t, size: 11)
            self.diary.font = UIFont(name: self.font_t, size: 14)
            self.weather.font = UIFont(name: self.font_t, size: 11)
            self.city.font = UIFont(name: self.font_t, size: 11)
        }
        if(music != ""){
            do{
                let audioPath = Bundle.main.path(forResource: music, ofType: ".mp3")
                audioplayer = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
                audioplayer.play()
            }
            catch{
                print("no song")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    /*
        When the view appears, it will be animated.
    */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.transition(with: self.date, duration: 1.0, options: .transitionCrossDissolve, animations: {self.date.alpha = 1.0}, completion: nil)
        UIView.transition(with: self.diary, duration: 1.0, options: .transitionCrossDissolve, animations: {self.diary.alpha = 1.0}, completion: nil)
        UIView.transition(with: self.city, duration: 1.0, options: .transitionCrossDissolve, animations: {self.city.alpha = 1.0}, completion: nil)
        UIView.transition(with: self.weather, duration: 1.0, options: .transitionCrossDissolve, animations: {self.weather.alpha = 1.0}, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     When the button is clicked, the data will be deleted
     */
    @IBAction func saving(){
        deleteData()
        if(music != ""){
            if(audioplayer.isPlaying){
                audioplayer.stop()
            }
        }
        self.performSegue(withIdentifier: "delete", sender: self)
    }
    /*
     go back without saving current diary
 */
    @IBAction func back(){
        if(music != ""){
            if(audioplayer.isPlaying){
                audioplayer.stop()
            }
        }
        self.performSegue(withIdentifier: "delete", sender: self)
    }
    /*
     delete the diary from the database
     */

    func deleteData(){
        let path = "userInfo/" + cleanEmail
        let ref = Database.database().reference(withPath: path)
        let ref2 = ref.child("diary").child(id)
        ref2.removeValue()
    }

}
