//
//  WatchListViewController.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/15.
//

import Foundation
import UIKit

class WatchListViewController: UIViewController {
    private var searchTimer: Timer?
    
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
        searchResultsController.delegate = self

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
        
        
        // reset timer
        searchTimer?.invalidate()
        
        // kick off new timer
        // Optimize to reduce number of searches for when user stops typing
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            // Call API to Search
            APIManager.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        resultVC.update(with: response.result)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        resultVC.update(with: [])
                    }
                    print(error)
                }
            }
        })

        // Update result controllers
        
    }
}

// MARK: - extension SearchResultsViewControllerDelegate
extension WatchListViewController: SearchResultsViewControllerDelegate {
    func SearchResultsViewControllerDidSelect(searchResult: SearchResult) {
        // Present stock details for given selection
        print("did select: \(searchResult.displaySymbol)")
    }
}
