//
//  ImagesSearchViewController.swift
//  PixabayImageSearch
//
//  Created by Himanshu Sonker on 12/06/20.
//  Copyright © 2020 Pixabay Wynk. All rights reserved.
//

import UIKit
import SDWebImage
import SKPhotoBrowser

class ImagesSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var savedSearchArr: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let queryService = QueryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pixabay Images Search"
        tableView.tableFooterView = UIView()//
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    
    //Mark: Helpers
    private func saveSearchStr(of search: String) {
        let defaults = UserDefaults.standard
        var savedSearchResult = [String]()
        if let actual = defaults.array(forKey: Constants.SEARCHED_STR) as? [String] {
             savedSearchResult = actual
        }
        
        if !savedSearchResult.contains(search) {
            savedSearchResult.insert(search, at: 0)
            if savedSearchResult.count > 10 {
                savedSearchResult.removeLast()
            }
            
            defaults.set(savedSearchResult, forKey: Constants.SEARCHED_STR)
        }
        
    }
    
    private func getSavedSearchResult () ->[String] {
        let defaults = UserDefaults.standard
        var savedSearchResult = [String]()
        if let actual = defaults.array(forKey: Constants.SEARCHED_STR) as? [String] {
             savedSearchResult = actual
        }
        
        return savedSearchResult
    }

}

//MARK: SearchBar Delegates
extension ImagesSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        queryService.getSearchResults(searchTerm: searchText, page: 1) { [weak self] results, errorMessage in
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          
            self?.savedSearchArr.removeAll()
            
            if let results = results {
              
              self?.saveSearchStr(of: searchText)
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let listController = (storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController)
              
              listController.images = results
                listController.searchText = searchBar.text
              self?.navigationController?.pushViewController(listController, animated: false)
            }
            
            if !errorMessage.isEmpty {
              print("Search error: " + errorMessage)
            }
          
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        savedSearchArr = getSavedSearchResult()
    }
    
}

//Mark:-Tableview delgate and data source
extension ImagesSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSearchArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.SEARCH_IMAGES_CELL) as! ImagesSearchTableViewCell
        
        cell.labelSearchedStr.text = savedSearchArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.text = savedSearchArr[indexPath.row]
        searchBarSearchButtonClicked(searchBar)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

