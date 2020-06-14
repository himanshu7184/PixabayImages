//
//  AppDelegate.swift
//  PixabayImageSearch
//
//  Created by Himanshu Sonker on 12/06/20.
//  Copyright © 2020 Pixabay Wynk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AppController.shared.show(in: UIWindow(frame: UIScreen.main.bounds))
        return true
    }


}

