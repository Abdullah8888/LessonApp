//
//  SubjectTableViewCell.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 03/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubjectTableViewCell: UITableViewCell,  UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var lessonCollectionView: UICollectionView?
    @IBOutlet weak var chapterNname: UILabel?
    var lessons: [JSON] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lessonCollectionView?.dataSource = self
        self.lessonCollectionView?.delegate = self
        self.lessonCollectionView?.collectionViewLayout = self.getLayout()
        self.lessonCollectionView?.register(UINib(nibName: "LessonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LessonCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellWithChaptersData(chapterName: String, lessons: [JSON]) {
        self.chapterNname?.text = chapterName
        self.lessons = lessons
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lessons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonCollectionViewCell",
        for: indexPath) as! LessonCollectionViewCell
        let lessonName = self.lessons[indexPath.row]["name"].stringValue
        let iconUrl = self.lessons[indexPath.row]["icon"].stringValue
        cell.updateCellWithLessonData(lessonName: lessonName, iconUrl: iconUrl)
        return cell
    }
    
    func getLayout() -> UICollectionViewLayout{
        let layout:UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        print("height is \(self.lessonCollectionView?.frame.size.height)")
        layout.itemSize = CGSize(width: 124.0, height: (self.lessonCollectionView?.frame.size.height)!)
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        return layout as UICollectionViewLayout
    }
    
}
