//
//  MatchesViewController.swift
//  duelly
//
//  Created by Hi_Hu on 9/28/15.
//  Copyright © 2015 hi_hu. All rights reserved.
//

import UIKit

//class Event {
//    
//    let objectId: NSString? = ""
//    let title: NSString = ""
//    let description: String = ""
//    let location: String = ""
//    let dateString: String = ""
//    let timeString: String = ""
//    var attendeeArray: [String] = []     // an array of names
//    var eventImage: UIImage?
//    var eventImageFile: PFFile
//    
//    var subtitle: String {
//        get {
//            return "\(dateString)"
//        }
//    }
//    
//    var eventTime: String {
//        get {
//            return "\(timeString)"
//        }
//    }
//    
//    var eventLocation: String {
//        get {
//            return "\(location)"
//        }
//    }
//}

class Dice {
 
    var dotViewCollection = [UIView]()
 
    // variables that calculate the position for each dot on each side based on the superview's frame
    
    init() {
        for _ in 1...6 {
            let dotView = UIView(frame: CGRectMake(0, 0, 24, 24))
            dotView.backgroundColor = UIColor.yellowColor()
            dotView.layer.cornerRadius = 12
            dotViewCollection.append(dotView)
        }
    }
    
    func addToView(view: UIView) {
        for dotView in dotViewCollection {
            view.addSubview(dotView)
        }
    }
}

class MatchesViewController: UIViewController {
    
    @IBOutlet weak var thisView: UIView!

    var dice = Dice()
    
    override func viewDidLoad() {
        
        thisView.layer.cornerRadius = 90
        thisView.backgroundColor = UIColor.blackColor()
        
        super.viewDidLoad()

        dice.addToView(thisView)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
