//
//  SubjectCollectionViewCell.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 02/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class SubjectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var parentView: UIView?
    @IBOutlet weak var subjectName: UILabel?
    @IBOutlet weak var subjectIcon: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let initalBackgroundColors = [UIColor.init(red: 0.99, green: 0.44, blue: 0.18, alpha: 1.0),
        UIColor.init(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.0),
        UIColor.init(red: 0.00, green: 0.46, blue: 0.12, alpha: 1.0),
        UIColor.init(red: 0.89, green: 0.06, blue: 0.01, alpha: 1.0),
        UIColor.init(red: 0.53, green: 0.00, blue: 0.38, alpha: 1.0)]
        
        self.parentView?.backgroundColor = initalBackgroundColors[Int(arc4random_uniform(UInt32(initalBackgroundColors.count)))]
        
        
        self.subjectIcon?.tintColor = UIColor.white
        
    }
    
    func updateCellWithSubjectData(iconUrl: String, subjectName: String){
        self.subjectName?.text = subjectName
        if let url = URL(string: iconUrl) {
            if (url.absoluteString.count > 0) {
                self.subjectIcon?.sd_setImage(with: url, completed: { (image, error, cachType, url) in
                    if (error == nil) {
                    }
                })
            }
        }
        
    }

}
