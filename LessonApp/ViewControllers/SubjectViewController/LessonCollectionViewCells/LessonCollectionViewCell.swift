//
//  LessonCollectionViewCell.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 03/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class LessonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lessonIcon: UIImageView?
    @IBOutlet weak var lessonName: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCellWithLessonData(lessonName: String, iconUrl: String) {
        self.lessonName?.text = lessonName
        if let url = URL(string: iconUrl) {
            if (url.absoluteString.count > 0) {
                self.lessonIcon?.sd_setImage(with: url, completed: { (image, error, cachType, url) in
                    if (error == nil) {
                    }
                })
            }
        }
    }

}
