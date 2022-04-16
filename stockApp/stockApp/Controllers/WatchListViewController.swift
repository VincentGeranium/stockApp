//
//  WatchListViewController.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/15.
//

import Foundation
import UIKit

class WatchListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupSearchController()
    }
}

// MARK: - Private
extension WatchListViewController {
    private func setupSearchController() {
        let searchResultsController = SearchResultsViewController()
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        
    }
}

// MARK: - extension UISearchResultsUpdating
extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultVC = searchController.searchResultsController as? SearchResultsViewController,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        // Optimize to reduce number of searches for when user stops typing
        
        // Call API to Search
        
        // Update result controllers
        print(query)
    }
}
