//
//  ClientViewController.swift
//  Cube
//
//  Created by doumaaaaaaaa on 16/4/10.
//  Copyright © 2016 doumafang. All rights reserved.
//

import UIKit
import IJKMediaFramework
import NVActivityIndicatorView
import TTGEmojiRate
import SnapKit


class ClientViewController: UIViewController {
    
    let player = IJKFFMoviePlayerController(contentURL: kRTMPURL, withOptions: IJKFFOptions.optionsByDefault())
    let starView = StarsOverlay()
    let showView = NVActivityIndicatorView(frame:CGRectMake(0, 0, 120, 120))
    let array = ["F","S","L","B","R"];
    let bb = BlueTooth()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        removeNofication()
    }
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        addNofication()

        self.view.backgroundColor = UIColor.whiteColor()
        bb.openBB()
        
        player.scalingMode = .AspectFit
        player.shouldAutoplay = true
        player.view.frame = CGRectMake(0, 0, kSCREEN_HEIGHT*10/16, kSCREEN_HEIGHT)
        player.view.backgroundColor = UIColor.blackColor()
        view.addSubview(player.view)
        player.prepareToPlay()
        player.play()

        
        
        starView.frame = CGRectMake(0, 0, kSCREEN_HEIGHT*10/16, kSCREEN_HEIGHT)
        view.addSubview(starView)
        
//        let starbutton = ProfileButton()
//        starbutton.backgroundColor = UIColor.blackColor()
//        starbutton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        starbutton.titleLabel?.font = UIFont(name: "Gotham", size:17)
//        starbutton.setTitle("Start your player", forState: UIControlState.Normal)
//        view.addSubview(starbutton)
//        starbutton.layer.borderWidth = 1
//        starbutton.layer.masksToBounds = true
//        starbutton.layer.cornerRadius = 27
//        starbutton.layer.borderColor = UIColor.yellowColor().CGColor
//        starbutton.snp_makeConstraints { (make) in
//            make.centerX.equalTo(player.view)
//            make.centerY.equalTo(player.view).multipliedBy(1.2)
//            make.size.equalTo(CGSizeMake(193, 54))
//        }
//        starbutton.addTarget(self, action:#selector(self.startPlay(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        showView.center = CGPointMake(kSCREEN_HEIGHT*5/16, kSCREEN_HEIGHT/2)
        showView.color = UIColor.whiteColor()
        showView.type = NVActivityIndicatorType.BallSpinFadeLoader
        view.addSubview(showView)
        showView.startAnimation()
    
        let closeView = UIImageView(image:UIImage(named: "closeB"))
        closeView.userInteractionEnabled = true
        view.addSubview(closeView)
        closeView.snp_makeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(view).offset(20)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.gestureTap(_:)))
        closeView.addGestureRecognizer(tap)
    
        let iphoneImage = UIImageView(image: UIImage(named:"iphone"))
        iphoneImage.center = CGPointMake((kSCREEN_HEIGHT * 5/8 + kSCREEN_WIDTH)/2 , (kSCREEN_HEIGHT * 5/8 + kSCREEN_WIDTH)/2 - kSCREEN_HEIGHT * 6/8)
        iphoneImage.bounds.size = CGSizeMake(100, 100)
        iphoneImage.contentMode = UIViewContentMode.ScaleAspectFit
        view.addSubview(iphoneImage)
        
        let iphoneView = NVActivityIndicatorView(frame:CGRectMake(0, 0, 300, 300))
        iphoneView.center = iphoneImage.center
        iphoneView.color = UIColor.blackColor()
        iphoneView.type = NVActivityIndicatorType.BallScaleRippleMultiple
        view.addSubview(iphoneView)
        iphoneView.startAnimation()
        
        for i in 0  ..< array.count
        {
            let button = ProfileButton()
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont(name: "Museo500-Regular", size: 30)
            button.setTitle(array[i], forState: UIControlState.Normal)
            view.addSubview(button)
            button.layer.borderWidth = 2
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 40
            button.layer.borderColor = UIColor.blackColor().CGColor
            if i == 1 {
                button.backgroundColor = UIColor.redColor()
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                button.layer.borderColor = UIColor.whiteColor().CGColor

            }

            
            button.tag = i
            button.snp_makeConstraints { (make) in
                if i == 0
                {
                    make.centerX.equalTo(iphoneImage)
                    make.bottom.equalTo(view).offset(-140)
                }
                    
                else if i == 1
                {
                    make.centerX.equalTo(iphoneImage).offset(120)
                    make.bottom.equalTo(view).offset(-140)
                }
                    
                else{
                    make.centerX.equalTo(iphoneImage).offset((i-3)*120)
                    make.bottom.equalTo(view).offset(-20)
                }
                    make.size.equalTo(CGSizeMake(100, 100))
            }
            button.addTarget(self, action:#selector(self.sendBBdata(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    
    func addNofication()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.moviePlayBackStateDidChange(_:)), name: IJKMoviePlayerPlaybackStateDidChangeNotification, object: player)
        
    }
    
    func moviePlayBackStateDidChange(send:NSNotification)
    {
        print("adasdasdad\(player.playbackState)")

        switch player.playbackState {
            
        case .Playing:
            starView.removeFromSuperview()
            showView.removeFromSuperview()
            return
        default:
            return
            
        }
    }
    
    func removeNofication()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: IJKMoviePlayerPlaybackStateDidChangeNotification, object: player)
    }
    
    func sendBBdata(sender: ProfileButton) {
        sender.animateTouchUpInside {
            self.bb.sendDataToBB(self.array[sender.tag])
        
        }
    }
    
    func startPlay(sender:ProfileButton)
    {
        sender.animateTouchUpInside{
        }
    }

    
    
    func gestureTap(gestureRecognizer: UIGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion:{
            self.player.pause()
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
