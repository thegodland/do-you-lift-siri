//
//  IntentHandler.swift
//  intentHandler
//
//  Created by 刘祥 on 3/1/19.
//  Copyright © 2019 xiangliu90. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INStartWorkoutIntentHandling, INEndWorkoutIntentHandling {
    //this is to handle the end
    func handle(intent: INEndWorkoutIntent, completion: @escaping (INEndWorkoutIntentResponse) -> Void) {
        print("end workout \(intent)")
        
        print("end of work out")
        
        
        var userActivities : NSUserActivity? = nil
        
        guard let spokenPhrase = intent.workoutName?.spokenPhrase else{
            completion(INEndWorkoutIntentResponse(code: .failureNoMatchingWorkout, userActivity: userActivities))
            return
        }
        
        if spokenPhrase == "chest" || spokenPhrase == "run" || spokenPhrase == "leg" || spokenPhrase == "shoulder" || spokenPhrase == "abs" || spokenPhrase == "arm" || spokenPhrase == "back" || spokenPhrase == "legs"{
            completion(INEndWorkoutIntentResponse(code: .handleInApp , userActivity: userActivities))
        }else{
            completion(INEndWorkoutIntentResponse(code: .failureNoMatchingWorkout, userActivity: nil))
        }
        
        
    }
    
    
    func handle(intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        print("startworkout \(intent)")
        
        var userActivities : NSUserActivity? = nil
        
        guard let spokenPhrase = intent.workoutName?.spokenPhrase else{
            completion(INStartWorkoutIntentResponse(code: .failureNoMatchingWorkout, userActivity: userActivities))
            return
        }
        
        if spokenPhrase == "chest" || spokenPhrase == "run" || spokenPhrase == "leg" || spokenPhrase == "shoulder" || spokenPhrase == "abs" || spokenPhrase == "arm" || spokenPhrase == "back" || spokenPhrase == "legs"{
            completion(INStartWorkoutIntentResponse(code: .handleInApp , userActivity: userActivities))
        }else{
            completion(INStartWorkoutIntentResponse(code: .failureNoMatchingWorkout, userActivity: nil))
        }
    }
    

 
}
