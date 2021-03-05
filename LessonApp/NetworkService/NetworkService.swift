//
//  NetworkService.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 01/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import Foundation
import SwiftyJSON

class NetworkService: NSObject {
    //A singleton object
    public static let sharedManager = NetworkService()
    
    //MARK: Download video
    public func downloadVideo(videoUrl: String, urlSessionDelegate: URLSessionDelegate) {
        guard let url = URL(string: videoUrl) else {
            debugPrint("Invalid Url")
            return
        }
        //let session = URLSession(configuration: .default, delegate: urlSessionDelegate, delegateQueue: .main);
//        URLSession.shared.downloadTask(with: url) { fileUrl, response, error
//            in
//            
//            if let error = error {
//                debugPrint("The error is: \(error.localizedDescription)")
//            }
//            
//        }
//        session.downloadTask(with: url) { (fileUrl, response, error) -> Void in
//            if let fileUrl = fileUrl {
//                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
//                    completion(true, fileUrl, response)
//                } else {
//                    completion(false, fileUrl, response!)
//                }
//            }
//        }.resume();
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: urlSessionDelegate, delegateQueue: .main)
        //let stringUrl = URL(string: url)
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    //MARK: User
    public func getLessons(completion: @escaping (_ success: Bool, _ object: SwiftyJSON.JSON?, _ response: URLResponse) -> ()) {
        
        let urlString = "https://jackiechanbruteforce.ulesson.com/3p/api/content/grade"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        get(request: request) { (success, object, response) in
            completion(success, object, response)
        }
    }
    
    private func post(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: SwiftyJSON.JSON?, _ response: URLResponse) -> ()) {
           dataTask(request: request, method: "POST", completion: completion)
       }
       
    private func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: SwiftyJSON.JSON?, _ response: URLResponse) -> ()) {
       dataTask(request: request, method: "GET", completion: completion)
    }
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: SwiftyJSON.JSON?, _ response: URLResponse) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: .default);
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let obj = try? JSON(data: data)
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, obj, response)
                } else {
                    completion(false, obj, response!)
                }
            }
        }.resume();
    }
}
