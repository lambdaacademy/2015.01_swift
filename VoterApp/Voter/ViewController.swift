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
        self.loveButton.contentMode = UIViewContentMode.center
        self.neutralButton.contentMode = UIViewContentMode.center
        self.hateButton.contentMode = UIViewContentMode.center
    }
    
    // Actions
    @IBAction func smileButtonPressed(_ sender: UIButton) {
        self.vm.makeVote(Vote.like(Date(), self.talkId))
        self.animateButton(sender)
        self.pieChart.reloadData();
    }
    
    @IBAction func donnoPressed(_ sender: UIButton) {
        self.vm.makeVote(Vote.neutral(Date(), self.talkId))
        self.animateButton(sender)
        self.pieChart.reloadData();
    }
    
    @IBAction func cryingPressed(_ sender: UIButton) {
        self.vm.makeVote(Vote.hate(Date(), self.talkId))
        self.animateButton(sender)
        self.pieChart.reloadData();
    }
    
    @IBAction func lambdaLogoLongPressed(_ sender: AnyObject) {
        if (self.view.isUserInteractionEnabled == false) {
            return; // already in progress
        }
        
        let apiDic = [
            "id":self.talkId!,
            "plus_votes":self.vm.likes().count,
            "zero_votes":self.vm.neutrals().count,
            "minus_votes":self.vm.hates().count
        ] as [String : Any]
        
        let api = VoteUploader()
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.talkTitleLabel.text = "\(self.talkName) - submiting votes..."
        api.submitVotes(apiDic, succeded: {
            let a = UIAlertView()
            a.title = "Succeded"
            a.message = "Votes data has been properly submited"
            a.delegate = self
            a.addButton(withTitle: "OK")
            a.show()
            self.talkTitleLabel.text = self.talkName
        }, failed: { (error) in
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            let a = UIAlertView()
            a.title = "Failed"
            if let e = error {
                a.message = e.localizedDescription
            }
            a.addButton(withTitle: "OK")
            a.show()
            self.talkTitleLabel.text = self.talkName            
        })
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    // Animation
    
    func animateButton(_ btn : UIButton) {
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
        
        
        
        UIView.animate(withDuration: 0.2, animations: {
//            width.constant*=2;
//            height.constant*=2;
            btn.transform = CGAffineTransform(scaleX: 2, y: 2)  // simpler way, without constraits
//            btn.layoutIfNeeded()
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.5, animations: {
                btn.transform = CGAffineTransform.identity // simpler way, without constraits
//                width.constant/=2;
//                height.constant/=2;
                btn.layoutIfNeeded()
            })
        })
        
        switch(self.vm.median) {
        case Vote.like :
            medianImage.image = UIImage(named: "love.png")
            medianLabel.isHidden = false
        case Vote.neutral :
            medianImage.image = UIImage(named: "donno.png")
            medianLabel.isHidden = false
        case Vote.hate :
            medianImage.image = UIImage(named: "crying.png")
            medianLabel.isHidden = false
        default :
            medianImage.image = nil
            medianLabel.isHidden = true
        }
    }
    
    // Pie Chart
    func numberOfSlices(in pieChart: XYPieChart!) -> UInt {
        return 3
    }
    
    func pieChart(_ pieChart: XYPieChart!, valueForSliceAt index: UInt) -> CGFloat {
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
    
    func pieChart(_ pieChart: XYPieChart!, colorForSliceAt index: UInt) -> UIColor! {
        switch (index) {
        case 0:
            return UIColor.green.withAlphaComponent(0.6)
        case 1:
            return UIColor.blue.withAlphaComponent(0.6)
        case 2:
            return UIColor.red.withAlphaComponent(0.6)
        default:
            return nil
        }
    }
}

