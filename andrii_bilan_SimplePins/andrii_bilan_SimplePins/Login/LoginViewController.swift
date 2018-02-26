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
var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "User", keyForSort: "name")
    var user: User?
    @IBAction func faceBookLogin(_ sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            self.fetchProfile()
            self.performSegue(withIdentifier: "showMap", sender: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(FBSDKAccessToken.current() != nil) {
            performSegue(withIdentifier: "showMap", sender: nil)
        } else {
            print("not logged in")
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
            if self.checkIfUserEverLogin(userId: (userInfo["id"] as? String)!) {
                self.performSegue(withIdentifier: "showMap", sender: nil)
            } else {
                 self.addUserToCoreData(userInfo)
            }
        }
    }
    
    func checkIfUserEverLogin(userId: String) -> Bool {
        let predicate = NSPredicate(format: "userID == %@", userId)
        let fetchRequest = fetchedResultsController.fetchRequest
          fetchRequest.predicate = predicate
        var userArray:[User] = []
        do {
            userArray = (try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [User])!
        } catch {
            print("Error fetch")
        }
        if userArray.isEmpty {
            return false
        }
        return true
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
        }
    }
}
