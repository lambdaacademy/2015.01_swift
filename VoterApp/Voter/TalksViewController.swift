//
//  TalksViewController.swift
//  Voter
//
//  Created by Krzysztof Profic on 23/02/15.
//  Copyright (c) 2015 Lambda Academy. All rights reserved.
//

import UIKit

class TalksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = "aa"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc: ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Voting") as ViewController
        vc.talkId = "1"
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}
