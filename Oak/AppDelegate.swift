//
//  AppDelegate.swift
//  Oak
//
//  Created by Alex Catchpole on 15/05/2021.
//

import Foundation
import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color("AccentColor"))
        
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect.zero)
        
        WatchSessionService.sharedManager.startSession()
     return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       print(error.localizedDescription)
    }
}
