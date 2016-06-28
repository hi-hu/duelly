//
//  Extensions.swift
//  duelly
//
//  Created by Andrew Schreiber on 6/27/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import Foundation

extension Int {
    func ordinalSuffix() -> String {
        let ones: Int = self % 10
        let tens: Int = Int(floor(Float(self) / Float(10))) % 10
        var suffix: String = "th"
        
        if (tens != 1) {
            switch(ones) {
            case 1:
                suffix = "st"
            case 2:
                suffix = "nd"
            case 3:
                suffix = "rd"
            default:
                break
            }
        }
        
        return suffix
    }
}