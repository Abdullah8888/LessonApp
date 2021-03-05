//
//  MainViewModel.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 01/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

enum MainViewModelState {
    case MainViewModelDidFetchLessons
    case MainViewModelFetchingLessonFails
    case MainViewModelDidExtractVideosData
    case MainViewModelExtractVideosDataFails
}

protocol MainViewModelDelegate: class {
    func MainViewModelDidChangeState(state: MainViewModelState)
}

class MainViewModel: NSObject, UICollectionViewDataSource, UITableViewDataSource {
    
    var delegate: MainViewModelDelegate?
    private var persistenceManager : PersistenceManager = PersistenceManager.sharedManager
    var lessons: JSON = [:]
    var lessons2: [String: [JSON]] = [:]
    var subjects: [JSON] = []
    var videos: [JSON] = []
    var videoCount = 1
    
    
    //MARK: Register CollectionView
    public func registerReusableViewsForCollectionView(collectionView: UICollectionView) {
        
        //Register the custom collectionView cells
        collectionView.register(UINib(nibName: "SubjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubjectCollectionViewCell")
        collectionView.dataSource = self
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCollectionViewCell",
        for: indexPath) as! SubjectCollectionViewCell
        let iconUrl = self.subjects[indexPath.row]["icon"].stringValue
        let subjectName = self.subjects[indexPath.row]["name"].stringValue
        cell.updateCellWithSubjectData(iconUrl: iconUrl, subjectName: subjectName)
        
        return cell
    }
    
    //MARK: Register TableView
    public func registerReusableViewsForTableView(tableView: UITableView) {
        
        //Register the custom tableView cells
        tableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoTableViewCell")
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count now is \(videoCount)")
        
        if self.videos.count > 1 {
            return self.videoCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "VideoTableViewCell",
        for: indexPath) as! VideoTableViewCell
        let videoData = self.videos[indexPath.row]
        cell.selectionStyle = .none
        cell.updateCellWithLessonVideoData(videosData: videoData)
        return cell
    }
    
    func getLessons() {
        if (self.persistenceManager.isLessonDataAvailable()) {
            let lessonData = self.persistenceManager.fetchLessonata()
            print("cached lesson \(lessonData)")
            if lessonData != JSON.null {
                self.subjects = lessonData["data"]["subjects"].arrayValue
                self.savedVideos()
                self.delegate?.MainViewModelDidChangeState(state: .MainViewModelDidFetchLessons)
            }
        }
        else {
            NetworkService.sharedManager.getLessons { (success, data, response) in
                if success {
                    DispatchQueue.main.async {
                        if (data!["data"]["subjects"] != JSON.null) {
                            let subjects = data!["data"]["subjects"].arrayValue
                            self.subjects = subjects
                            self.persistenceManager.saveLessons(data: data!)
                            self.extratAllVideos(subjects: subjects)
                            self.delegate?.MainViewModelDidChangeState(state: .MainViewModelDidFetchLessons)
                        }
                    }
                }
                else {
                    self.delegate?.MainViewModelDidChangeState(state: .MainViewModelFetchingLessonFails)
                }
            }
            
        }
        
    }
    
    func extratAllVideos(subjects: [JSON]) {
        var videosData: [JSON] = []
        var lesson: JSON = [:]
        for subject in subjects {
            lesson["name_of_subject"] = subject["name"]
            for chapter in subject["chapters"].arrayValue {
                for subLesson in chapter["lessons"].arrayValue {
                    lesson["id"] = subLesson["id"]
                    lesson["name"] = subLesson["name"]
                    lesson["icon"] = subLesson["icon"]
                    lesson["media_url"] = subLesson["media_url"]
                    videosData.append(lesson)
                }
            }
        }
        print(self.lessons)
        
        if !videosData.isEmpty {
            let json: JSON = [
                "videos": videosData,
            ]
            self.lessons = json
            print("lesson2 \(json)")
            self.videos = json["videos"].arrayValue
            self.delegate?.MainViewModelDidChangeState(state: .MainViewModelDidExtractVideosData)
            self.persistenceManager.saveVideos(data: json)
        }
    }
    
    public func savedVideos() {
        if (self.persistenceManager.isVideoDataAvailable()) {
            let videoData = self.persistenceManager.fetchVideoData()
            print("from cached video \(videoData)")
            
            self.videos = videoData["videos"].arrayValue
            self.delegate?.MainViewModelDidChangeState(state: .MainViewModelDidExtractVideosData)
        }
    }
}

