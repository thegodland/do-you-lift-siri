//
//  ViewController.swift
//  do you lift
//
//  Created by 刘祥 on 3/1/19.
//  Copyright © 2019 xiangliu90. All rights reserved.
//

import UIKit
import Intents
import SCSDKCreativeKit
//import SwiftGifOrigin
//import Alamofire
//import SwiftyJSON

class ViewController: UIViewController {
    
    var userdefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(handleSiriRequest), name: NSNotification.Name("workoutStartNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEndSiriRequest), name: NSNotification.Name("workoutEndNotification"), object: nil)
        
        INVocabulary.shared().setVocabularyStrings(["abs", "leg", "arm","back","chest","shoulder","legs"], of: .workoutActivityName)

        
        INPreferences.requestSiriAuthorization { (status) in
            if status == INSiriAuthorizationStatus.authorized{
                print("authorized")
            }else{
                print("not authorized")
            }
        }
    }
    
    @objc func handleEndSiriRequest(){
        
        print("this is end snap")
        
        guard let intent = DataService.instance.endWorkoutIntent,
            let workoutType = intent.workoutName?.spokenPhrase else{
                print("there is a error with handler")
                return
        }
        
        let timestamp = NSDate().timeIntervalSince1970
        let startstamp = userdefaults.double(forKey: "time")
        let difference = (timestamp - startstamp)/1000 //will change to seconds
        
        sendEndToSnap(workoutType,difference)
        
    }
    
    func sendEndToSnap(_ name:String, _ completedtime:TimeInterval){
        
        print("this is end snap")
        
        //to compare goal in seconds with difference of timestmap
        let goal = userdefaults.double(forKey: "goal")
        var sentence = ""
        let diffmins = (goal-completedtime)/60
        if goal > completedtime{
            // finish early
        
            sentence = "\(name) workout failed...less than goal with \(diffmins) minutes"
        }else{
            
            sentence = "I just snapped \(name) workout! work hard more than goal with \(abs(diffmins)) minutes"
            
        }
        
        var url : String?
        //        var stickerImage : UIImage?
        switch name {
        case "chest": url = "https://media.giphy.com/media/1334O1WETb3sIM/giphy.gif"
        case "leg", "legs": url = "https://media.giphy.com/media/pHWPutvnDlMj6nHP5S/giphy.gif"
        case "back": url = "https://media.giphy.com/media/Iju5lihY5MgG4/giphy.gif"
        case "abs": url = "https://media.giphy.com/media/10SH7mBIo4RAys/giphy.gif"
        case "arm": url = "https://media.giphy.com/media/d2Z2g31pfyc64jgk/giphy.gif"
        case "run": url = "https://media.giphy.com/media/NPXH9DAWLf5hm/giphy.gif"
        case "shoulder": url = "https://media.giphy.com/media/1441zlMyzrOs9y/giphy.gif"
        default: url = ""
            //        default: stickerImage = UIImage.gif(url: "https://media.giphy.com/media/1334O1WETb3sIM/giphy.gif")
        }
        
        guard let urlGuard = url else {return}
        let gifurl = URL(string: urlGuard)
        guard let realurl = gifurl else{return}
        
        let sticker = SCSDKSnapSticker(stickerUrl: realurl, isAnimated: true)

        let snap = SCSDKNoSnapContent()
        snap.sticker = sticker /* Optional */
        snap.caption = sentence
        
        let api = SCSDKSnapAPI(content: snap)
        api.startSnapping(completionHandler: { (error: Error?) in
            /* Do something */
            if let error = error{
                print("this is error of snap \(error)")
            }else{
                print("succeed to snap")
            }
        })
        
        
        
    }

    
    @objc func handleSiriRequest(){
        guard let intent = DataService.instance.startWorkoutIntent, let goalValue = intent.goalValue,
            let workoutType = intent.workoutName?.spokenPhrase else{
                print("there is a error with handler")
                return
        }
        
        //to process the snap chat create sticker 
        
//        print("the workout type is \(workoutType)")
//        print(goalValue.convertToTimeFormat())
//        sendHttpRequestToGIY(searchWord: workoutType) { (url) in
//            if self.gifurl == nil{
//                self.gifurl = url
//                print(url)
//            }
//        }
        
        //get the local time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateInFormat = dateFormatter.string(from: NSDate() as Date)
        
        let timestamp = NSDate().timeIntervalSince1970
        userdefaults.set(timestamp, forKey: "time")
        userdefaults.set(goalValue, forKey: "goal") // keep as seconds

        sendStickerToSnap(workoutType, date: dateInFormat, time: goalValue.convertToTimeFormat())

    }
    
    //get gif
//    func sendHttpRequestToGIY(searchWord:String, completion:@escaping (String)->()) {
//        let url = "http://api.giphy.com/v1/stickers/search"
//
//        let params = ["api_key":"ATGsfZGl0u2MeBGn7Wrwq0Xcuj3wrp65", "q":searchWord, "limit":3] as [String : Any]
//
//        Alamofire.request(url, method:.get, parameters:params).responseJSON { (response) in
//
//            let randomIndex = Int.random(in: 0...4)
//            print("the random number is \(randomIndex)")
//
//            if response.result.isSuccess {
//                print("this is success")
//                let json = JSON(response.result.value!)
//                let gifurl = json["data"][randomIndex]["url"].string
//                guard let gifURL = gifurl else{return}
//                completion(gifURL)
//            }else{
//                print("we have a problem here \(String(describing: response.result.error))")
//            }
//        }
//    }
    
    func sendStickerToSnap(_ name:String, date:String, time:String){
        
//        print("this code should be executed")
        /* Stickers to be used in Snap */
//        let stickerImage = UIImage(named: name)
            var url : String?
//        var stickerImage : UIImage?
        switch name {
        case "chest": url = "https://media.giphy.com/media/1334O1WETb3sIM/giphy.gif"
        case "leg", "legs": url = "https://media.giphy.com/media/pHWPutvnDlMj6nHP5S/giphy.gif"
        case "back": url = "https://media.giphy.com/media/Iju5lihY5MgG4/giphy.gif"
        case "abs": url = "https://media.giphy.com/media/10SH7mBIo4RAys/giphy.gif"
        case "arm": url = "https://media.giphy.com/media/d2Z2g31pfyc64jgk/giphy.gif"
        case "run": url = "https://media.giphy.com/media/NPXH9DAWLf5hm/giphy.gif"
        case "shoulder": url = "https://media.giphy.com/media/1441zlMyzrOs9y/giphy.gif"
        default: url = ""
//        default: stickerImage = UIImage.gif(url: "https://media.giphy.com/media/1334O1WETb3sIM/giphy.gif")
        }
        
//        let stickerImage = UIImage.gif(url: "https://media.giphy.com/media/1334O1WETb3sIM/giphy.gif")
        /* Prepare a sticker image */
    
//        guard let img = stickerImage else{
//            return
//        }
        
//        print(img)
//        let sticker = SCSDKSnapSticker(stickerImage: img)
        /* Alternatively, use a URL instead */
    

        guard let urlGuard = url else {return}
        let gifurl = URL(string: urlGuard)
        guard let realurl = gifurl else{return}
        
        let sticker = SCSDKSnapSticker(stickerUrl: realurl, isAnimated: true)
        sticker.posX = 0.3
        sticker.posY = 0.3
    
        /* Modeling a Snap using SCSDKNoSnapContent */
        
        //        try to add two stickers
        let snap = SCSDKNoSnapContent()
        snap.sticker = sticker /* Optional */
        snap.caption = "\(date) I am going to snap \(name) for \(time) minutes" /* Optional */
        
        /* Optional */
        
        let api = SCSDKSnapAPI(content: snap)
        api.startSnapping(completionHandler: { (error: Error?) in
            /* Do something */
            if let error = error{
                print("this is error of snap \(error)")
            }else{
                print("succeed to snap")
            }
        })
    }
    


}

