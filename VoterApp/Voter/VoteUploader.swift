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
    func submitVotes(_ votes: NSDictionary, succeded: (() -> Void)?, failed: ((_ error: NSError?) -> Void)? = nil )
    {
        print("Votes: \(votes)")
        var request = URLRequest(url: URL(string: updateURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Request: \(request)")
        
        let bodyData: Data?
        do {
            bodyData = try JSONSerialization.data(withJSONObject: votes, options: JSONSerialization.WritingOptions(rawValue: 0))
        } catch let error as NSError {
            // TODO failed
            bodyData = nil
        }
        print("string: \(NSString(data: bodyData!, encoding: String.Encoding.utf8.rawValue))")
        request.httpBody = bodyData
        print("bodyData: \(bodyData)")
        print("headers: \(request.allHTTPHeaderFields)")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            let httpResp = response as? HTTPURLResponse
            print("Response: \(response)")
            if let data = data {
                let strData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("Body: \(strData)")
            }
//            var err: NSError?
//            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err)
            if (httpResp?.statusCode == 200) {
                if let s = succeded {
                    s()
                }
            }
            else {
                failed?(error as NSError?)
            }
        })
        
        task.resume()
    }
    
    func getTalks(_ succeded: ((NSArray) -> Void)?, failed: ((_ error: NSError?) -> Void)? = nil )
    {
        var request = URLRequest(url: URL(string: talksURL)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Request: \(request)")
        

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            print("Response: \(response)")
            print("Error: \(error)")
            
            if let httpResp = response as? HTTPURLResponse {
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Body: \(strData)")

                do {
                    let json: NSDictionary! = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSDictionary
                    if (httpResp.statusCode == 200 && json != nil) {
                        if let s = succeded {
                            s(json["talks"] as! NSArray!)
                        }
                    }
                    else {
                        failed?(error as NSError?)
                    }
                }
                catch {
                    failed?(error as NSError?)
                }
            }
        })
        
        task.resume()
    }
}
