//
//  ImagesListViewController.swift
//  PixabayImageSearch
//
//  Created by Himanshu Sonker on 13/06/20.
//  Copyright © 2020 Pixabay Wynk. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class ImagesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var images: Images?
    var imagesList = [Hits]()
    var searchText: String!
    
    let queryService = QueryService()
    
    var totalImages = 0
    var currentImageOffset = 0
    var isLoadingData = false
    var footerView: UIView!
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = searchText
        tableView.tableFooterView = UIView()//
        tableView.dataSource = self
        tableView.delegate = self
        
        totalImages = images?.totalHits ?? 0//load more case
        initFooterView()//load more case
        
        if let list = images?.hits {
            imagesList = list
            currentImageOffset = imagesList.count
        }
    }
    
    //Mark: Helpers
    
    private func getAllImagesUrls () ->[SKPhoto] {
        
        // 1. create URL Array
        var images = [SKPhoto]()
        for hit in imagesList {
            let photo = SKPhoto.photoWithImageURL(hit.webformatURL ?? "")
            photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
            images.append(photo)
        }
        
        return images
    }
    
    func initFooterView () {
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        let actInd = UIActivityIndicatorView(style: .gray)
        actInd.tag = 10
        actInd.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - 10, y: 10, width: 20.0, height: 20.0)
        actInd.hidesWhenStopped = true
        footerView.addSubview(actInd)
    }

}

extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement = imagesList.count - 1
        
        if !isLoadingData && totalImages != currentImageOffset && indexPath.row == lastElement {
            tableView.tableFooterView = footerView
            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
            isLoadingData = true
           
            DispatchQueue.global(qos: .background).async {
                self.getNextPageImages()
            }
        }
        
        if totalImages == currentImageOffset {
            tableView.tableFooterView = UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.IMAGES_LIST_CELL) as! ImagesListTableViewCell
        
        let hit = imagesList[indexPath.row]
        
        if let imgUrlStr = hit.previewURL, let imgURL = URL(string: imgUrlStr) {
            cell.thumbImage.sd_setImage(with: imgURL, completed: nil)
        } else {
            cell.thumbImage.image = UIImage(named: "")
        }
        
        cell.labelImageTags.text = hit.tags
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: getAllImagesUrls())
        browser.initializePageIndex(indexPath.row)
        present(browser, animated: true, completion: {})
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }
    
    
}

//Mark:- Load more Images
extension ImagesListViewController {
    
    func getNextPageImages () {
        
        currentPage = currentPage + 1
        queryService.getSearchResults(searchTerm: searchText, page: currentPage) { [weak self] results, errorMessage in
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self?.isLoadingData = false
            if let results = results {
                if let hits = results.hits {
                    self?.imagesList.append(contentsOf: hits)
                    self?.currentImageOffset = (self?.imagesList.count)!
                }
                
                self?.tableView.reloadData()
            }
            
            if !errorMessage.isEmpty {
              print("Search error: " + errorMessage)
            }
          
          
        }
    }
    
}

