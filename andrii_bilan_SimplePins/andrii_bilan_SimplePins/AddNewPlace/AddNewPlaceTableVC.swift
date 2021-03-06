//
//  AddNewPlaceTableVC.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/24/18.
//  Copyright © 2018 Andrii. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class AddNewPlaceTableVC: UITableViewController {
    var placesLocation: Location?
    var place: Place?
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeDescription: UITextView?

    
    @IBAction func saveNewPlace(_ sender: UIButton) {
    if savePlace() {
            dismiss(animated: true, completion: nil)
        }
    }

    func savePlace() -> Bool {
        if (placeName.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "You must write place's name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        // Creating object
        if place == nil {
            place = Place()
        }
        // Saving object
        if let place = place {
            place.name = placeName.text
            place.descriptions = placeDescription?.text
            place.latitude = (placesLocation?.latitude)!
            place.longitude = (placesLocation?.longitude)!
            place.date = Date() as NSDate
            place.userID = FBSDKAccessToken.current().userID
            CoreDataManager.instance.saveContext()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
