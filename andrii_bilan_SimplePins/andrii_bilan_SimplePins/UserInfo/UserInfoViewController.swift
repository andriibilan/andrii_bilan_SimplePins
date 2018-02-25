//
//  UserInfoViewController.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/24/18.
//  Copyright © 2018 Andrii. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userinfo: UIView!
    
    @IBAction func logOut(_ sender: UIButton) {
        let manager = FBSDKLoginManager()
        manager.logOut()
        performSegue(withIdentifier: "showLogOut", sender: nil)
    }
    
    @IBAction func cancelUserInfo(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
            }
        });
    }
    
}
