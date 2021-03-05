//
//  SubjectViewController.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 03/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubjectViewController: GenericViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var subjectTableView: UITableView?
    @IBOutlet weak var subjectName: UILabel?
    @IBOutlet weak var leftArrow: UIImageView?
    
    var subjects: [JSON] = []
    var chapters: [JSON] = []
    var subjectTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.subjectTableView?.register(UINib.init(nibName: "SubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "SubjectTableViewCell")
        self.subjectTableView?.delegate = self
        self.subjectTableView?.dataSource = self
        let tapLeftArrow = UITapGestureRecognizer(target: self, action: #selector(self.onBackPressed))
        self.leftArrow?.addGestureRecognizer(tapLeftArrow)
        self.setSubjectName()
    }
    
    @objc func onBackPressed(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setSubjectName() {
        self.subjectName?.text = "\(self.subjectTitle ?? "")"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if self.chapters.count > 0 {
            count = chapters.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectTableViewCell",
        for: indexPath) as! SubjectTableViewCell
        let chapterName = self.chapters[indexPath.row]["name"].stringValue
        let lessons = self.chapters[indexPath.row]["lessons"].arrayValue
        cell.updateCellWithChaptersData(chapterName: chapterName, lessons: lessons)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }

}
