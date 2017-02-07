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
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        }, failed: { (error) -> Void in
            OperationQueue.main.addOperation({
                self.activityIndicator.stopAnimating()
            })
        })
        // Do any additional setup after loading the view.
    }
   
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let t = talks {
            return t.count
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if let tss = talks {
            let dict = tss[indexPath.row] as! NSDictionary
            cell.textLabel?.text = dict.value(forKey: "title") as! String?
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tss = talks {
            let vc: ViewController = self.storyboard?.instantiateViewController(withIdentifier: "Voting") as! ViewController
            let dict = tss[indexPath.row] as! NSDictionary
            let talkId = dict.value(forKey: "id") as! Int
            vc.talkId = "\(talkId)"
            vc.talkName = dict.value(forKey: "title") as! String?
            self.present(vc, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
