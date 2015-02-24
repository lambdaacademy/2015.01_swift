//
//  ViewController.swift
//  Voter
//
//  Created by Krzysztof Profic on 14/12/14.
//  Copyright (c) 2014 Lambda Academy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XYPieChartDataSource, UIAlertViewDelegate {
    var talkId: String!
    var talkName: String!
    lazy var vm: VoteManager = {
       return VoteManager(tId: self.talkId)
    }()
    
    @IBOutlet weak var pieChart: XYPieChart!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var hateButton: UIButton!
    @IBOutlet weak var medianImage: UIImageView!
    @IBOutlet weak var medianLabel: UILabel!
    @IBOutlet weak var talkTitleLabel: UILabel!
    
    @IBOutlet weak var likeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var neutralWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var neutralHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hateWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var hateHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Life cycle
    override func viewDidLoad() {
        self.talkTitleLabel.text = self.talkName
        self.pieChart.reloadData()
        self.loveButton.contentMode = UIViewContentMode.Center
        self.neutralButton.contentMode = UIViewContentMode.Center
        self.hateButton.contentMode = UIViewContentMode.Center
    }
    
    // Actions
    @IBAction func smileButtonPressed(sender: UIButton) {
        self.vm.makeVote(Vote.Like(NSDate(), self.talkId))
        self.animateButton(sender)
        self.pieChart.reloadData();
    }
    
    @IBAction func donnoPressed(sender: UIButton) {
        self.vm.makeVote(Vote.Neutral(NSDate(), self.talkId))
        self.animateButton(sender)
        self.pieChart.reloadData();
    }
    
    @IBAction func cryingPressed(sender: UIButton) {
        self.vm.makeVote(Vote.Hate(NSDate(), self.talkId))
        self.animateButton(sender)
        self.pieChart.reloadData();
    }
    
    @IBAction func lambdaLogoLongPressed(sender: AnyObject) {
        if (self.view.userInteractionEnabled == false) {
            return; // already in progress
        }
        
        let apiDic = [
            "id":self.talkId!,
            "plus_votes":self.vm.likes().count,
            "zero_votes":self.vm.neutrals().count,
            "minus_votes":self.vm.hates().count
        ]
        
        let api = VoteUploader()
        self.activityIndicator.startAnimating()
        self.view.userInteractionEnabled = false
        self.talkTitleLabel.text = "\(self.talkName) - submiting votes..."
        api.submitVotes(apiDic, succeded: {
            let a = UIAlertView()
            a.title = "Succeded"
            a.message = "Votes data has been properly submited"
            a.delegate = self
            a.addButtonWithTitle("OK")
            a.show()
            self.talkTitleLabel.text = self.talkName
        }, failed: { (error) in
            self.activityIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            
            let a = UIAlertView()
            a.title = "Failed"
            if let e = error {
                a.message = e.localizedDescription
            }
            a.addButtonWithTitle("OK")
            a.show()
            self.talkTitleLabel.text = self.talkName            
        })
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Animation
    
    func animateButton(btn : UIButton) {
        var width: NSLayoutConstraint! = {
            switch (btn) {
            case self.loveButton :
                return self.likeWidthConstraint
            case self.neutralButton:
                return self.neutralWidthConstraint
            case self.hateButton:
                return self.hateWidthConstraint
            default: ()
            }
            return nil
        }()
        
        var height: NSLayoutConstraint! = {
            switch (btn) {
            case self.loveButton :
                return self.likeHeightConstraint
            case self.neutralButton:
                return self.neutralHeightConstraint
            case self.hateButton:
                return self.hateHeightConstraint
            default: ()
            }
            return nil
        }()
        
        
        
        UIView.animateWithDuration(0.2, animations: {
//            width.constant*=2;
//            height.constant*=2;
            btn.transform = CGAffineTransformMakeScale(2, 2)  // simpler way, without constraits
//            btn.layoutIfNeeded()
        }, completion: { _ in
            
            UIView.animateWithDuration(0.5, animations: {
                btn.transform = CGAffineTransformIdentity // simpler way, without constraits
//                width.constant/=2;
//                height.constant/=2;
                btn.layoutIfNeeded()
            })
        })
        
        switch(self.vm.median) {
        case Vote.Like :
            medianImage.image = UIImage(named: "love.png")
            medianLabel.hidden = false
        case Vote.Neutral :
            medianImage.image = UIImage(named: "donno.png")
            medianLabel.hidden = false
        case Vote.Hate :
            medianImage.image = UIImage(named: "crying.png")
            medianLabel.hidden = false
        default :
            medianImage.image = nil
            medianLabel.hidden = true
        }
    }
    
    // Pie Chart
    func numberOfSlicesInPieChart(pieChart: XYPieChart!) -> UInt {
        return 3
    }
    
    func pieChart(pieChart: XYPieChart!, valueForSliceAtIndex index: UInt) -> CGFloat {
        switch (index) {
        case 0:
            return CGFloat(self.vm.likes().count)
        case 1:
            return CGFloat(self.vm.neutrals().count)
        case 2:
            return CGFloat(self.vm.hates().count)
        default:
            return 0
        }
    }
    
    func pieChart(pieChart: XYPieChart!, colorForSliceAtIndex index: UInt) -> UIColor! {
        switch (index) {
        case 0:
            return UIColor.greenColor().colorWithAlphaComponent(0.6)
        case 1:
            return UIColor.blueColor().colorWithAlphaComponent(0.6)
        case 2:
            return UIColor.redColor().colorWithAlphaComponent(0.6)
        default:
            return nil
        }
    }
}

