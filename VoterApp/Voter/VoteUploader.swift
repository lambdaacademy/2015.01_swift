//
//  VoteUploader.swift
//  Voter
//
//  Created by Wojciech Nagrodzki on 22/02/15.
//  Copyright (c) 2015 Lambda Academy. All rights reserved.
//

import Foundation

let updateURL = "http://xmpp.lambdadays.org:4000/talk_api/update"


class VoteUploader: NSObject
{
    func submitVotes(votes: NSDictionary)
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
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err)
        })
        
        task.resume()
    }
}
