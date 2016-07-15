//
//  TopPunishmentViewController
//  LateManagement
//
//  Created by administrasion on 7/14/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import LTMorphingLabel

class TopPunishmentViewController: UIViewController {
    @IBOutlet weak var nameLabel: LTMorphingLabel!
    @IBOutlet weak var cntLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    let spinUnit = CGFloat(M_PI_4 / 2)
    var topPunishment: TopPunishment?
    
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return true
        }
        
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        avatarImageView.setImageByURL(NSURL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1468323122808&di=4df1db5565c01157cc1ddf8a3683c99c&imgtype=jpg&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2015-01-07%2F231358320.jpg")!)
        self.nameLabel.morphingEffect = .Anvil
        self.getTopPunishment()
    }
    
    func getTopPunishment() {
        User.loginUser?.teams.last?.getTopPunishemnt {
            topPunishment, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let topPunishment = topPunishment {
                self.topPunishment = topPunishment
                self.playAnimation()
                self.nameLabel.text = topPunishment.user.name
            }
        }
    }
    
    
    func playAnimation() {
        guard let topPunishment = self.topPunishment else {return}
        self.cntLabel.transform = CGAffineTransformMakeScale(0.25, 0.25)
        self.cntLabel.font = UIFont.italicSystemFontOfSize(60)
        self.cntLabel <- "\(topPunishment.total)元"
        self.cntLabel.sizeToFit()
        self.cntLabel.clipsToBounds = false
        
        for i in 0 ..< 20 {
            let label = UILabel()
            
            label.text = "💰"
            
            label.frame = CGRect(origin: CGPoint(x: (CGFloat(arc4random()) / CGFloat(UInt32.max)) * self.view.frame.width, y: 0), size: .zero)
            label.sizeToFit()
            label.transform = CGAffineTransformMakeScale(2, 2)
            self.view.addSubview(label)
            UIView.animateWithDuration(4, delay: Double(i) * 0.2, options: [], animations: {
                label.transform = CGAffineTransformTranslate(label.transform, (CGFloat(arc4random()) / CGFloat(UInt32.max)) * self.view.frame.width, UIScreen.mainScreen().bounds.height)
            }) {
                _ in
                label.removeFromSuperview()
            }
        }
        
        self.spin(CGFloat(M_PI * 4))
        
        UIView.animateWithDuration(4 * 8 * 0.04, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.cntLabel.transform = CGAffineTransformIdentity
            self.cntLabel.textColor = UIColor.flatYellowColor()
            }, completion: {
                _ in
                //                self.cntLabel.sizeToFit()
        })
    }


    func spin(angle: CGFloat, comletionHandler: SimpleBlock? = nil) {
        UIView.animateWithDuration(0.04, delay: 0, options: [], animations: {
            self.cntLabel.transform = CGAffineTransformRotate(self.cntLabel.transform, self.spinUnit)
        }) {
            complete in
            if angle < self.spinUnit {
                UIView.animateWithDuration(0.04, delay: 0, options: [.CurveEaseOut], animations: {
                    self.cntLabel.transform = CGAffineTransformRotate(self.cntLabel.transform, angle - self.spinUnit)
                }) {
                    _ in
                    comletionHandler?()
                }
            } else {
                self.spin(angle - self.spinUnit, comletionHandler: comletionHandler)
            }
        }
    }
}
