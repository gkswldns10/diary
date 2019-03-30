//
//  FontsViewController.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 4/30/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit



class FontsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var fontTable: UITableView!
    let in_font = UIFont.familyNames
    override func viewDidLoad() {
        super.viewDidLoad()
        fontTable.delegate = self
        fontTable.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.in_font.count)
        return self.in_font.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fontTable.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.in_font[indexPath.row]
        cell?.textLabel?.font = UIFont(name:self.in_font[indexPath.row], size : 15)
        cell?.textLabel?.textColor = UIColor.black
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    /*
     global variable = currentFont
     
     Change the currentFont variable which holds the current font variable.
 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        currentFont = self.in_font[indexPath.row]
        
        self.performSegue(withIdentifier: "doneFont", sender: self)
       
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
