//
//  PersistenceManager.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 02/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import Foundation
import MagicalRecord
import SwiftyJSON

class PersistenceManager: NSObject {
    public static let sharedManager = PersistenceManager()
    private var lessonData : Lessons!
    private var videoData : Videos!
    
    public func setupDataStack() {
        MagicalRecord.setupCoreDataStack(withStoreNamed: "LessonAppDataModel")
        self.saveContext()
    }
    
    public func saveLessons(data: JSON) {
        if (self.lessonData != nil) {
            self.lessonData.mr_deleteEntity()
        }
        self.lessonData = Lessons.mr_createEntity()
        self.lessonData.lessons = try? data.rawData() as NSObject
        self.saveContext()
    }
    
    public func saveVideos(data: JSON) {
        if (self.videoData != nil) {
            self.videoData.mr_deleteEntity()
        }
        self.videoData = Videos.mr_createEntity()
        self.videoData.videos =  try? data.rawData() as NSObject
        self.saveContext()
    }
    
    public func isLessonDataAvailable() -> Bool {
        self.lessonData = Lessons.mr_findFirst()
        if (self.lessonData != nil) {
            return true
        }
        else {
            return false
        }
    }
    
    public func isVideoDataAvailable() -> Bool {
        self.videoData = Videos.mr_findFirst()
        if (self.videoData != nil) {
            return true
        }
        else {
            return false
        }
    }
    
    public func fetchLessonata() -> JSON {
        if (self.lessonData != nil) {
            let result = self.lessonData.lessons as! Data
            let json = try? JSON.init(data: result)
            return json!
        }
        else {
            return JSON.null
        }
    }
    
    public func fetchVideoData() -> JSON {
        if (self.videoData != nil) {
            let result = self.videoData.videos as! Data
            let json = try? JSON.init(data: result)
            return json!
        }
        else {
            return JSON.null
        }
    }
    
    public func saveContext() {
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    public func clearVideoData() {
        Videos.mr_truncateAll()
    }
    
    public func clearLessonData() {
        Lessons.mr_truncateAll()
    }
}
