//
//  AppDelegate.swift
//  LessonApp
//
//  Created by Jimoh Babatunde  on 01/03/2021.
//  Copyright © 2021 Jimoh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil);
        navController = UINavigationController(rootViewController: mainViewController);
        window?.rootViewController = navController;
        window?.makeKeyAndVisible()
        
        //Setup our Core Data Stack with our presistence manager
        PersistenceManager.sharedManager.setupDataStack()
        
        return true
    }

}

extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 5111
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.backgroundColor = UIColor.red

                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
    
    
    
}

