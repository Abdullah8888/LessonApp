//
//  MainViewController.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 01/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import UIKit

class MainViewController: GenericViewController, MainViewModelDelegate, UICollectionViewDelegate, UITableViewDelegate {
    
    
    @IBOutlet weak var loader: UIActivityIndicatorView?
    @IBOutlet weak var subjectCollectionView: UICollectionView?
    
    @IBOutlet weak var viewAllBtn: UIButton?
    @IBOutlet weak var videosTableViewHeight: NSLayoutConstraint?
    @IBOutlet weak var videosTableView: UITableView?
    private let viewModel = MainViewModel()
    private var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader?.isHidden = false
        self.loader?.startAnimating()
        self.viewModel.delegate = self
        self.subjectCollectionView?.delegate = self
        self.viewModel.getLessons()
        self.subjectCollectionView?.contentInset = UIEdgeInsets.zero
        self.viewModel.registerReusableViewsForCollectionView(collectionView: self.subjectCollectionView!)
        self.videosTableView?.delegate = self
        self.viewModel.registerReusableViewsForTableView(tableView: self.videosTableView!)
        self.subjectCollectionView?.collectionViewLayout = self.getLayout()
        //PersistenceManager.sharedManager.clearVideoData()
    }
    
    func MainViewModelDidChangeState(state: MainViewModelState) {
        switch state {
        case .MainViewModelDidFetchLessons:
            self.subjectCollectionView?.reloadData()
            self.loader?.stopAnimating()
            self.loader?.isHidden = true
        case .MainViewModelFetchingLessonFails:
            print("Error, while try to response")
        case .MainViewModelDidExtractVideosData:
            self.videosTableView?.reloadData()
        case .MainViewModelExtractVideosDataFails:
            print("Error, while trying extract videos")
        }
    }
    
    func getLayout() -> UICollectionViewLayout {
        let layout:UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width/2)-25, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 10.0
        
        return layout as UICollectionViewLayout
    }
    
    @IBAction func viewAll(_ sender: UIButton) {
        
        if self.isExpanded == false {
            UIView.animate(withDuration: 0.5, animations: {
                self.videosTableViewHeight?.constant = 250.0
                
            }, completion: { (finished: Bool) in
                self.isExpanded = true
                self.viewAllBtn?.setTitle("SEE LESS", for: .normal)
                self.viewModel.videoCount = self.viewModel.videos.count
                self.videosTableView?.reloadData()
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.videosTableViewHeight?.constant = 130.0
                
            }, completion: { (finished: Bool) in
                self.isExpanded = false
                self.viewAllBtn?.setTitle("VIEW ALL", for: .normal)
                self.viewModel.videoCount = 1
                self.videosTableView?.reloadData()
            })
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subjectTitle = self.viewModel.subjects[indexPath.row]["name"].stringValue
        let chapters = self.viewModel.subjects[indexPath.row]["chapters"].arrayValue
        let subjectViewController = SubjectViewController(nibName: "SubjectViewController", bundle: nil)
        subjectViewController.subjectTitle = subjectTitle
        subjectViewController.chapters = chapters
        self.navigationController?.pushViewController(subjectViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoData = self.viewModel.videos[indexPath.row]
        let videoPlayerViewController = VideoPlayerViewController(nibName: "VideoPlayerViewController", bundle: nil)
        videoPlayerViewController.videoUrl = videoData["media_url"].stringValue
        videoPlayerViewController.videoId = videoData["id"].int8Value
        self.navigationController?.pushViewController(videoPlayerViewController, animated: true)
    }
    
}
