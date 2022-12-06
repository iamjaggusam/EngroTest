//
//  FilesTableViewCell.swift
//  EngroTest
//
//  Created by JaGgu Sam on 06/12/22.
//

import UIKit

class FilesTableViewCell: UITableViewCell {

    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func loadData(data: [String: Any]) {
        fileName.text = data["name"] as? String ?? ""
        let filename: NSString = data["name"] as? NSString ?? "example.doc"
        let pathExtention = filename.pathExtension
        self.fileImage.image = getImage(fileExtension: pathExtention)
    }
    
    func getImage(fileExtension: String) -> UIImage {
        switch fileExtension {
            case "doc", "docx":
                return UIImage(named: "doc")!
            case "pdf":
                return UIImage(named: "pdf")!
            default:
                return UIImage(named: "textFile")!
        }
    }
}
