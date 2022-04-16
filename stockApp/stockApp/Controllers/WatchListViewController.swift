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
        setupTitleView()
    }
}

// MARK: - Private
extension WatchListViewController {
    private func setupTitleView() {
        let titleView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: navigationController?.navigationBar.height ?? 100
            )
        )
        
        let titleLabel: UILabel = {
            let label: UILabel = UILabel(
                frame: CGRect(
                    x: 10,
                    y: 0,
                    width: titleView.width-20,
                    height: titleView.height
                )
            )
            
            label.text = "Stocks"
            label.font = .systemFont(ofSize: 40.0, weight: .medium)
            
            return label
        }()

        titleView.addSubview(titleLabel)
        
        navigationItem.titleView = titleView
    }
    
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
