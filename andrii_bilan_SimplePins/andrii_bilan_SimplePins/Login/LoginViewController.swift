//
//  LoginViewController.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/23/18.
//  Copyright © 2018 Andrii. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email"]
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        //       let accessToken = FBSDKAccessToken.current()
        //       if accessToken != nil {
        //            print("LoggedIn")
        //        } else {
        //            print("Not loggedIn")
        //
        //        }
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, name, picture.height(200).width(200)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print("Error")
                return
            }
            guard let userInfo = result as? [String:Any] else { return }
            
          //  self.emailTextField.text = userInfo["email"] as? String
           // self.firstNameTextField.text = userInfo["name"] as? String
            if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                
                let profileImageURL = imageURL
                let url = URL(string: profileImageURL)
                let data = try? Data(contentsOf: url!)
               //     self.profileImage.image = UIImage(data: data!)
            }
        }
        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil {
            print("login complete")
            //self.performSegueWithIdentifier("showLogin", sender: self)
        }else{
            print(error.localizedDescription)
            //com.facebook.sdk.core error 8.
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    
}
