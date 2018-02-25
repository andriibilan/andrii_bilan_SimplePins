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

class LoginViewController: UIViewController {
    var user: User?
    
    @IBAction func faceBookLogin(_ sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            self.fetchProfile()
            print("`````\(FBSDKAccessToken.current().description)")
            self.performSegue(withIdentifier: "showMap", sender: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(FBSDKAccessToken.current() != nil) {
            // logged in
            print("```````logged in")
            performSegue(withIdentifier: "showMap", sender: nil)
        } else {
            print("``````not logged in")
            // not logged in
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, name, picture.height(200).width(200)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print("Error")
                return
            }
            guard let userInfo = result as? [String:Any] else { return }
            self.addUserToCoreData(userInfo)
//            if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
//                let profileImageURL = imageURL
//                print(imageURL)
//                let url = URL(string: profileImageURL)
//                let data = try? Data(contentsOf: url!)
//               //     self.profileImage.image = UIImage(data: data!)
//            }
        }
    }
    
    func addUserToCoreData(_ userInfo: [String: Any]) {
        if  user == nil {
            user = User()
        }
        if let user = user {
            user.name = userInfo["name"] as? String
            user.email = userInfo["email"] as? String
            let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
            user.photo = imageURL
            user.userID = userInfo["id"] as? String
            CoreDataManager.instance.saveContext()
            print("``````````User have this Data:\(user.debugDescription)")
        }
    }
}
