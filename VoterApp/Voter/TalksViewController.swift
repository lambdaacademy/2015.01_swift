//
//  TalksViewController.swift
//  Voter
//
//  Created by Krzysztof Profic on 23/02/15.
//  Copyright (c) 2015 Lambda Academy. All rights reserved.
//

import UIKit

class TalksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var talks: NSArray?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let vu = VoteUploader()
        self.activityIndicator.startAnimating()
        vu.getTalks({ (talks: NSArray) -> Void in
            self.talks = talks
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        }, failed: { (error) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.activityIndicator.stopAnimating()
            })
        })
        // Do any additional setup after loading the view.
    }
   
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let t = talks {
            return t.count
        }
        
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        if let tss = talks {
            cell.textLabel?.text = tss[indexPath.row]["title"] as String?
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let tss = talks {
            let vc: ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Voting") as ViewController
            let talkId = tss[indexPath.row]["id"] as Int
            vc.talkId = "\(talkId)"
            vc.talkName = tss[indexPath.row]["title"] as String?
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
