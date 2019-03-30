//
//  SongTableViewController.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 4/23/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit
import AVFoundation
class SongTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var songtable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songtable.delegate = self
        songtable.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     set up the table view of the songs.
 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = songtable.dequeueReusableCell(withIdentifier: "cell")
        print(songs[indexPath.row])
        cell?.textLabel?.text = songs[indexPath.row]
        cell?.textLabel?.textColor = UIColor.white
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    /*
     when the song is chosen it plays the music and goes back to previous VC 
 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            currentlyPlaying = songs[indexPath.row]
            let audioPath = Bundle.main.path(forResource: songs[indexPath.row], ofType: ".mp3")
            audioplayer = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioplayer.play()
            self.performSegue(withIdentifier: "donesong", sender: self)
        }
        catch{
            print("Error")
        }
    }

}
