//
//  DataService.swift
//  do you lift
//
//  Created by 刘祥 on 3/2/19.
//  Copyright © 2019 xiangliu90. All rights reserved.
//

import Foundation
import Intents

class DataService{
    static let instance = DataService()
    var startWorkoutIntent: INStartWorkoutIntent?
    var endWorkoutIntent: INEndWorkoutIntent?
}
