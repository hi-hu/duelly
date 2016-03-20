//
//  Constants.swift
//  duelly
//
//  Created by Hi_Hu on 10/5/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import Foundation
import UIKit

//// Global Constants
let cornerRadius: CGFloat = 3
let letterSpacing = 4


struct Colors {
    static let green200    = UIColor(red: 0.133, green: 1, blue: 0.364, alpha: 1.0)
    static let green500    = UIColor(red: 0.274, green: 0.705, blue: 0.572, alpha: 1.0)
    static let asphalt500  = UIColor(red: 0.157, green: 0.380, blue: 0.501, alpha: 1.0)
    static let asphalt700  = UIColor(red: 0.066, green: 0.109, blue: 0.208, alpha: 1.0)
    static let purple700   = UIColor(red: 0.098, green: 0.074, blue: 0.396, alpha: 1.0)
    static let pink200     = UIColor(red: 1, green: 0.278, blue: 0.627, alpha: 1.0)
    static let pink500     = UIColor(red: 0.984, green: 0.0, blue: 0.47, alpha: 1.0)
    static let yellow500   = UIColor(red: 246/255, green: 198/255, blue: 30/255, alpha: 1.0)
    static let yellow700   = UIColor(red: 255/255, green: 176/255, blue: 30/255, alpha: 1.0)
    
    
    static func createGradientLayer(frame: CGRect, color1: UIColor, color2: UIColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        
        // creating the gradient color and its layer frame
        gradientLayer.frame = frame
        gradientLayer.colors = [color1.CGColor, color2.CGColor]

        return gradientLayer
    }
}

/*
var mutableString = NSMutableAttributedString(string: event.title as String, attributes: [NSKernAttributeName: 4] )

UISegmentedControl.appearance().setTitleTextAttributes([
NSFontAttributeName: UIFont(name: "DINNextLTPro-Light", size: 14.0)!,
NSKernAttributeName: 3,
NSBaselineOffsetAttributeName: -0.5
], forState: .Normal)



class func attributedString(string text:String, withFont font:UIFont!, kerning: CGFloat!, andColor color:UIColor!) -> NSAttributedString?  {
return NSAttributedString(string: text, attributes: [NSKernAttributeName:kerning, NSFontAttributeName:font, NSForegroundColorAttributeName:color])
}

let attributedText:NSAttributedString? = AppearanceService.attributedString(string: "Kern it, Kern it good.", withFont: AppearanceService.mediumFont(size: 15), kerning: 1.5, andColor: UIColor.whiteColor())

*/

