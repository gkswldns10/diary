//
//  authViewController.swift
//  DiaryApp
//
//  Created by  Jeewwon Han on 4/24/18.
//  Copyright © 2018  Jeewwon Han. All rights reserved.
//

import UIKit
import LocalAuthentication

class authViewController: UIViewController {
    var dairytext = ""
    var dairydate = ""
    var id = ""
    var music = ""
    var city = ""
    var weather = ""
    var font_t = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var authenticationObject = LAContext()
        var error:NSError?
        // Do any additional setup after loading the view.
        
        /*
         it authenticates the user and if authentication is verified it goes to locked diary. 
 */
        authenticationObject.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error != nil {
            print("auth is not available")
        }
        else{
            authenticationObject.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "you can access the diary with your finger print", reply: { (complete, t_error) in
                if t_error != nil{
                    print(t_error?.localizedDescription)
                }
                else{
                    if complete == true {
                        print("Authentication Successful")
                        let mainStroyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVc = mainStroyBoard.instantiateViewController(withIdentifier: "readDiaryViewController") as! readDiaryViewController
                        destVc.dairytext = self.dairytext
                        destVc.dairydate = self.dairydate
                        destVc.id = self.id
                        destVc.music = self.music
                        destVc.city_t = self.city
                        destVc.weather_t = self.weather
                        destVc.font_t = self.font_t
                        DispatchQueue.main.sync {
                            self.navigationController?.pushViewController(destVc, animated: true)
                        }
                    }
                    else{
                        print("error")
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
