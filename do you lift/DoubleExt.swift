//
//  DoubleExt.swift
//  do you lift
//
//  Created by 刘祥 on 3/2/19.
//  Copyright © 2019 xiangliu90. All rights reserved.
//

import Foundation

extension Double {
    func convertToTimeFormat() -> String{
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%0d:%02d", minutes, seconds )
        
    }
}

