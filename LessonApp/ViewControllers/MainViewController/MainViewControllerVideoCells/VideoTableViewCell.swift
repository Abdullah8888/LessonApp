//
//  VideoTableViewCell.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 03/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var playIcon: UIImageView?
    @IBOutlet weak var videoBg: UIImageView?
    @IBOutlet weak var subjectName: UILabel?
    @IBOutlet weak var lessonName: UILabel?
    let playIcons = [UIImage(named: "green_oval"), UIImage(named: "orange_oval"), UIImage(named: "purple_oval")]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let initalBackgroundColors = [UIColor.init(red: 0.99, green: 0.44, blue: 0.18, alpha: 1.0),
        UIColor.init(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.0),
        UIColor.init(red: 0.00, green: 0.46, blue: 0.12, alpha: 1.0),
        UIColor.init(red: 0.89, green: 0.06, blue: 0.01, alpha: 1.0),
        UIColor.init(red: 0.53, green: 0.00, blue: 0.38, alpha: 1.0)]
        
        self.subjectName?.textColor = initalBackgroundColors[Int(arc4random_uniform(UInt32(initalBackgroundColors.count)))]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellWithLessonVideoData(videosData: JSON) {
        print("sub \(videosData)")
        self.subjectName?.text = videosData["name_of_subject"].stringValue
        self.lessonName?.text = videosData["name"].stringValue
        let iconUrl = videosData["icon"].stringValue
        if let icon = self.playIcons.randomElement() {
           self.playIcon?.image = icon
        }
        
        if let url = URL(string: iconUrl) {
            if (url.absoluteString.count > 0) {
                self.videoBg?.sd_setImage(with: url, completed: { (image, error, cachType, url) in
                    if (error == nil) {
                    }
                })
            }
        }
        
        
    }
    
}
