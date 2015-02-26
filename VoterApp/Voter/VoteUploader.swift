//
//  VoteUploader.swift
//  Voter
//
//  Created by Wojciech Nagrodzki on 22/02/15.
//  Copyright (c) 2015 Lambda Academy. All rights reserved.
//

import Foundation

let updateURL = "http://xmpp.lambdadays.org/talk_api/update"
let talksURL = "http://xmpp.lambdadays.org/talk_api/index"

class VoteUploader: NSObject
{
    func submitVotes(votes: NSDictionary, succeded: (() -> Void)?, failed: ((error: NSError?) -> Void)? = nil )
    {
        println("Votes: \(votes)")
        var request = NSMutableURLRequest(URL: NSURL(string: updateURL)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        println("Request: \(request)")
        
        var err: NSError?
        let bodyData = NSJSONSerialization.dataWithJSONObject(votes, options: NSJSONWritingOptions(0), error: &err)
        println("string: \(NSString(data: bodyData!, encoding: NSUTF8StringEncoding))")
        request.HTTPBody = bodyData
        println("bodyData: \(bodyData)")
        println("headers: \(request.allHTTPHeaderFields)")
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            let httpResp = response as NSHTTPURLResponse
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
//            var err: NSError?
//            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err)
            if (httpResp.statusCode == 200) {
                if let s = succeded {
                    s()
                }
            }
            else {
                if let f = failed {
                    f(error: error)
                }
            }
        })
        
        task.resume()
    }
    
    func getTalks(succeded: ((NSArray) -> Void)?, failed: ((error: NSError?) -> Void)? = nil )
    {
        var request = NSMutableURLRequest(URL: NSURL(string: talksURL)!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        println("Request: \(request)")
        
        var err: NSError?
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            let httpResp = response as NSHTTPURLResponse
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            if (httpResp.statusCode == 200 && json != nil) {
                if let s = succeded {
                    s(json["talks"] as NSArray!)
                }
            }
            else {
                if let f = failed {
                    f(error: error)
                }
            }
        })
        
        task.resume()
    }
}
