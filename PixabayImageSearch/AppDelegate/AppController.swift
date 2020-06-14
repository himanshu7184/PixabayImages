//
//  AppController.swift
//  PixabayImageSearch
//
//  Created by Himanshu Sonker on 12/06/20.
//  Copyright © 2020 Pixabay Wynk. All rights reserved.
//

import UIKit


final class AppController {
  
    static let shared = AppController()
  
    private var window: UIWindow!
  
    private var rootViewController: UIViewController? {
      didSet {
        if let vc = rootViewController {
          window.rootViewController = vc
        }
      }
    }
  
  
    // MARK: - Helpers
    func show(in window: UIWindow?) {
      guard let window = window else {
        fatalError("Cannot layout app with a nil window.")
      }
      
      
      self.window = window
      //window.tintColor = .primary
      //window.backgroundColor = .white
      
      handleAppState()
      
      window.makeKeyAndVisible()
    }
    
    private func handleAppState() {
      let vc = getSearchViewController()
      rootViewController = NavigationController(vc)
    }
  
    private func getSearchViewController () ->UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchController = (storyboard.instantiateViewController(withIdentifier: "ImagesSearchViewController") as! ImagesSearchViewController)
        return searchController
    }
  
}
