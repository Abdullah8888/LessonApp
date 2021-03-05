//
//  VideoPlayerViewController.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 04/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import UIKit
import AVKit
import PhotosUI
class VideoPlayerViewController: GenericViewController, VideoPlayerViewModelDelegate, URLSessionDownloadDelegate{
    
    
    
    @IBOutlet weak var playIcon: UIImageView?
    @IBOutlet weak var fastForwardVideo: UIView?
    @IBOutlet weak var reverseVideo: UIView?
    @IBOutlet weak var leftArrow: UIImageView?
    @IBOutlet weak var startTime: UILabel?
    @IBOutlet weak var endTime: UILabel?
    @IBOutlet weak var progressView: UIProgressView?
    
    @IBOutlet weak var videoView: UIView?
    @IBOutlet weak var playerView: UIView?
    
    var videoUrl: String?
    var videoId: Int8?
    var avPlayer: AVPlayer?
    var isVideoDonePlaying = false
    var videoProgressView: UIProgressView?
    var videoProgressText: String?
    lazy var viewModel = VideoPlayerViewModel()
    var alertView: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapLeftArrow = UITapGestureRecognizer(target: self, action: #selector(self.leftArrowDidTapped))
        self.leftArrow?.addGestureRecognizer(tapLeftArrow)
        
        let tapVideoReverse = UITapGestureRecognizer(target: self, action: #selector(self.videoRewindDidTapped))
        self.reverseVideo?.addGestureRecognizer(tapVideoReverse)
        
        let tapVideoFastForward = UITapGestureRecognizer(target: self, action: #selector(self.videoFastForwardDidTapped))
        self.fastForwardVideo?.addGestureRecognizer(tapVideoFastForward)
        
        let tapPlay = UITapGestureRecognizer(target: self, action: #selector(self.playIconDidTapped))
        self.playIcon?.addGestureRecognizer(tapPlay)
        self.setVideoToPlay()
        
        self.getVideoFromDevice()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.progressView?.progress = 0.0
        self.isVideoDonePlaying = true
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        self.playIcon?.image = UIImage(named: "play_icon")
    }
    
    func setVideoToPlay() {
        //Check if it downloaded, if not show pop that ask user if he/she wanna download the video
        //self.showAlertForVideoDownload()
    }
    
    @objc func leftArrowDidTapped(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func videoRewindDidTapped(_ sender: UITapGestureRecognizer) {
        self.rewindVideo(by: 10)
    }
    
    @objc func videoFastForwardDidTapped(_ sender: UITapGestureRecognizer) {
        self.forwardVideo(by: 10)
    }
    
    @objc func playIconDidTapped(_ sender: UITapGestureRecognizer) {
        if self.isVideoDonePlaying == true {
            
            self.avPlayer?.seek(to: .zero)
            self.isVideoDonePlaying = false
        }
        
        switch self.avPlayer?.timeControlStatus {
        case .paused:
            self.playIcon?.image = UIImage(named: "pause")
            self.avPlayer?.play()
        case .playing:
            self.playIcon?.image = UIImage(named: "play_icon")
            self.avPlayer?.pause()
        case .none:
            debugPrint("None")
        case .some(.waitingToPlayAtSpecifiedRate):
            debugPrint("waiting")
        case .some(_):
            debugPrint("some")
        }
    }
    
    func showAlertForVideoDownload() {
        let confimationAlert = UIAlertController(title: "", message: "Do you want to download this video", preferredStyle: UIAlertController.Style.alert)
        
        confimationAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.showVideoDownloadingProgress()
            return
        }))
        
        confimationAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            self.startPlayingVideo(filePath: self.videoUrl!, isFromDevice: false)
            return
        }))
        self.present(confimationAlert, animated: true, completion: nil)
    }
    
    func startPlayingVideo(filePath:String, isFromDevice: Bool) {
        
        DispatchQueue.main.async {
            
            if filePath != ""{
                self.avPlayer = AVPlayer(url: URL(fileURLWithPath: filePath))
            }
            else {
                guard let url = URL.init(string: filePath) else {
                    print("url seems to be wrong or contains error")
                    return
                }
                let asset = AVAsset(url: url)
                let playerItem = AVPlayerItem(asset: asset)
                self.avPlayer = AVPlayer(playerItem: playerItem)
            }
            
            
            
            // Create AVPlayerLayer object
            let playerLayer = AVPlayerLayer(player: self.avPlayer)
            playerLayer.frame = self.videoView!.frame
            playerLayer.videoGravity = .resizeAspectFill
            
            // Add playerLayer to video view layer
            self.videoView?.layer.addSublayer(playerLayer)
            
            self.avPlayer?.play()
            
            
            let interval = CMTime(value: 1, timescale: 2)
            self.avPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time in

                if self?.avPlayer?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
                    let totalDuration = self?.avPlayer?.currentItem?.duration
                    print("AVPlayer is ready to play")
                    let seconds = CMTimeGetSeconds(time)
                    let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                    let minutesString = String(format: "%02d", Int(seconds / 60))
                    self?.startTime?.text = "\(minutesString):\(secondsString)"
                    
                    let totalSeconds = CMTimeGetSeconds(totalDuration!)
                    let totalSecondsString = String(format: "%02d", Int(totalSeconds.truncatingRemainder(dividingBy: 60)))
                    let totalMinutesString = String(format: "%02d", Int(totalSeconds / 60))
                    self?.endTime?.text = "\(totalMinutesString):\(totalSecondsString)"
                    
                    if let duration = self?.avPlayer?.currentItem?.duration {
                        let durationSeconds = CMTimeGetSeconds(duration)
                        let seconds = CMTimeGetSeconds(time)
                        let progress = Float(seconds/durationSeconds)
                        self?.progressView?.progress = progress
                        if progress >= 1.0 {
                            self?.progressView?.progress = 0.0
                        }
                    }
                  
                }
               
                if self?.avPlayer?.currentItem?.status == AVPlayerItem.Status.failed {
                    print("AVPlayer failed")

                }

                if self?.avPlayer?.currentItem?.status == AVPlayerItem.Status.unknown {
                    print("AVPlayer is unknown")
                }
               })
        }
    }
    
    func rewindVideo(by seconds: Float64) {
        if let currentTime = self.avPlayer?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - seconds
            if newTime <= 0 {
                newTime = 0
            }
            self.avPlayer?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }

    func forwardVideo(by seconds: Float64) {
        if let currentTime = self.avPlayer?.currentTime(), let duration = self.avPlayer?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + seconds
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            self.avPlayer?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Setup progress bar for downloading
    func showVideoDownloadingProgress() {
        
        if let url = self.videoUrl {
            self.viewModel.delegate = self
            let urlTest = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Polarlicht_2.jpg/1920px-Polarlicht_2.jpg?1568971082971"
            print("sample url is \(url)")
            self.viewModel.downloadVideo(videoUrl: url, urlSessionDelegate: self)
        }
        else {
            print("video url not found")
        }
        
        self.videoProgressText = "Downloading ... "
        self.alertView = UIAlertController(title: "Please wait", message: self.videoProgressText, preferredStyle: .alert)
        self.alertView?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(self.alertView!, animated: true, completion: nil)
    
    }
    
    func downloadVideo() {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.videoProgressText = "Done"
        self.alertView?.message = "Done"
        print("the location url is \(location)")
        
        self.saveVideoToDevice(location: location, fileName: "\(self.videoId!).mp4")
        
        
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(progress)
        if progress > 0 {
            self.alertView?.message = "\(progress * 100)%"
        }
        
        
    }
    
    func VideoPlayerViewModelDidChangeState(state: VideoPlayerViewModelState) {
        switch state {
        case .VideoPlayerViewModelDidDownloadVideo:
            print("Video Success here")
        case .VideoPlayerViewModelDidDownloadVideoFails:
            print("Video Error here")
        }
    }
    
//    func VideoPlayerViewModelDidTrackDownloading(progress: Float) {
//        self.videoProgressView?.progress = progress
//        self.videoProgressText = "\(progress * 100)%"
//    }
//    
//    func VideoPlayerViewModelDidFinishDownloading(message: String, location: URL) {
//        self.videoProgressText = message
//        print("the location url is \(location)")
//    }
    
    func saveImageDocumentDirectory(content: Data?, fileName: String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
        
        //let image = UIImage(named: "apple.jpg")
        print("full path  \(paths)")
        //let imageData = UIImageJPEGRepresentation(image!, 0.5)
        
        //fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        fileManager.createFile(atPath: paths, contents: content, attributes: nil)
    }
    
    func saveVideoToDevice(location: URL, fileName: String) {
        let videoData = NSData(contentsOf: location)
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
        print("here 00 \(paths)")
        videoData?.write(toFile: paths, atomically: true)
        getVideoFromDevice()
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getVideoFromDevice(){
        guard let videoId = self.videoId else {
            print("video url not found")
            return
        }
        let fileManager = FileManager.default
        let videoPath = (self.getDirectoryPath() as NSString).appendingPathComponent("\(videoId).mp4")
    
        
        if fileManager.fileExists(atPath: videoPath){
            print("is there \(videoPath)")
            self.startPlayingVideo(filePath: videoPath, isFromDevice: true)
        }else{
            self.showAlertForVideoDownload()
        }
    }
    
    func test2() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!

        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            for item in items {
                print("Found \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
}
