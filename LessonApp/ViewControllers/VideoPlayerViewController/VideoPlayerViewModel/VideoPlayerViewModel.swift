//
//  VideoPlayerViewModel.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 04/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import Foundation

class VideoPlayerViewModel: NSObject {
    
    private var networkService : NetworkService = NetworkService.sharedManager
    
    func downloadVideo(videoUrl: String, urlSessionDelegate: URLSessionDelegate) {
        self.networkService.downloadVideo(videoUrl: videoUrl, urlSessionDelegate: urlSessionDelegate)
    }
    

}
