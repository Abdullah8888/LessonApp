//
//  GenericViewController.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 01/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import Foundation
import UIKit
import Reachability
import RKDropdownAlert

class GenericViewController: UIViewController {
    public var isThereConnection = true
    let reachability = try! Reachability()
    override func viewDidLoad() {
         self.navigationController?.navigationBar.isHidden = true
         if #available(iOS 13.0, *) {
             let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
              //statusBar.backgroundColor = UIColor.init(red: 243/250, green: 243/250, blue: 243/250, alpha: 1)
            statusBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
             statusBar.alpha = 0.2
             UIApplication.shared.keyWindow?.addSubview(statusBar)
         } else {
            
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            UIApplication.shared.statusBarView?.alpha = 0.2
            
         }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            debugPrint("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {

        let reachability = note.object as! Reachability

        switch reachability.connection {
        case .wifi:
            isThereConnection = true
            //self.removeBlurOverlay()
        case .cellular:
            isThereConnection = true
            //self.removeBlurOverlay()
        case .none:
            self.showAlertWithText(title: "No internet", text: "This App requires wifi/internet connection!")
            isThereConnection = false
        case .unavailable:
            self.showAlertWithText(title: "No internet", text: "This App requires wifi/internet connection!")
            isThereConnection = false
        }
    }
    
    //MARK: AlertView
    public func showAlertWithText(title: String, text: String) {
        let confimationAlert = UIAlertController(title: title, message: text, preferredStyle: UIAlertController.Style.alert)
        
        
        confimationAlert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (action: UIAlertAction!) in
            return
        }))
        self.present(confimationAlert, animated: true, completion: nil)
    }
    
    //MARK: DropDownAlert
    public func displayDropDownAlertWithTitle(title: String, message: String, error: Bool) {
        RKDropdownAlert.title(title, message: message, backgroundColor: error ? UIColor.init(named: "f05858") : UIColor.init(named: "66bb6a"), textColor: UIColor.white, time: 2)
    }
    
}
