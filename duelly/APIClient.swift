//
//  APIClient.swift
//  duelly
//
//  Created by Andrew Schreiber on 6/16/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import Foundation
import GoogleAPIClient
import GTMOAuth2

@objc class APIClient:NSObject {
    static let sharedInstance = APIClient()
    
    private let kKeychainItemName = "Google Sheets API"
    private let kClientID = "969166147434-6htpe46bi8h7rv6j40llb771e8mihj9n.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = ["https://www.googleapis.com/auth/spreadsheets.readonly"]
    
    private let service = GTLService()
    
    func authorizeClient() {
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
    }
    
    func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: #selector(APIClient.viewController(_:finishedWithAuth:error:))
        )
    }
    
   @objc func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
    if let error = error {
        service.authorizer = nil
        print("Auth error. \(error). \(error.localizedDescription)")
        return
    }
    
    service.authorizer = authResult
    vc.dismissViewControllerAnimated(true, completion: nil)
    listMajors()
    }
    
    func listMajors() {
        print("Getting sheet data")
        let baseUrl = "https://sheets.googleapis.com/v4/spreadsheets"
        let spreadsheetId = "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms"
        let range = "Class%20Data!A2:E"
        let url = String(format:"%@/%@/values/%@", baseUrl, spreadsheetId, range)
        let params = ["majorDimension": "ROWS"]
        let fullUrl = GTLUtilities.URLWithString(url, queryParameters: params)
        NSLog("Calling")
        service.fetchObjectWithURL(fullUrl,
                                   objectClass: GTLObject.self,
                                   delegate: self,
                                   didFinishSelector: #selector(APIClient.displayResultWithTicket(_:finishedWithObject:error:))
        )
    }
    
   @objc func displayResultWithTicket(ticket: GTLServiceTicket,
                                 finishedWithObject object : GTLObject,
                                                    error : NSError?) {
    NSLog("Retrieved")
        
        if let error = error {
            print("Got result error \(error). \(error.localizedDescription)")
            return
        }
        
        var majorsString = ""
        let rows = object.JSON["values"] as! [[String]]
        
        if rows.isEmpty {
            print("No data found")
            return
        }
        
        majorsString += "Name, Major:\n"
        for row in rows {
            let name = row[0] ?? "Unknown"
            let major = row[4] ?? "Unknown"
            
            majorsString += "\(name), \(major)\n"
        }
        
        print("Got majors string: \(majorsString)")
    }

    
    
}