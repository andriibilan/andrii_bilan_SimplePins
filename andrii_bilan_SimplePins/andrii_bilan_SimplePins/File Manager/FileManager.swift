//
//  FileManager.swift
//  andrii_bilan_SimplePins
//
//  Created by Andrii on 2/24/18.
//  Copyright © 2018 Andrii. All rights reserved.
//
import UIKit
import Foundation
class FileManagers {
    static let instances = FileManagers()

    func downloadImageToPath(_ photo: UIImage? )  -> String {
        guard photo != #imageLiteral(resourceName: "Design - Barcode") && photo != nil else {
            return ""
        }
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let uuidStringforURL = UUID().uuidString + ".jpg"
        let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(uuidStringforURL))// Change extension if you want to save as PNG
        do {
            try UIImageJPEGRepresentation(photo!, 1.0)?.write(to: imgPath, options: .atomic)
        } catch let error {
            print(error.localizedDescription)
        }
        return uuidStringforURL
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imageURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(path))
        do {
            let imageData = try Data(contentsOf: imageURL)
            return UIImage(data: imageData)!
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

