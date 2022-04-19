//
//  WatchListViewController.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/15.
//

import Foundation
import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {
    // Model objcet
    private var watchList: [String: [CandleStick]] = [:]
    
    // ViewModel
    private var viewModels: [String] = []
    
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        
        return tableView
    }()
    
    private var searchTimer: Timer?
    
    private var panel: FloatingPanelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupSearchController()
        setupTableView()
        fetchWatchListData()
        setupTitleView()
        setupFloatingPanel()
    }
}

// MARK: - Private
extension WatchListViewController {
    private func fetchWatchListData() {
        // Array of symbols
        let symbolDatas = PersistenceManager.shared.watchList
        
        let group = DispatchGroup()
        
        for symbol in symbolDatas {
            group.enter()
            
            APIManager.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let data):
                    let candleSticks = data.candleSticks
                    self?.watchList[symbol] = candleSticks
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        view.addSubViews(views: tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupFloatingPanel() {
        let vc = NewsViewController(controllerType: .topStories)
        let panel = FloatingPanelController()
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
        panel.delegate = self
        panel.track(scrollView: vc.tableView)
    }
    
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
        self.navigationItem.searchController?.searchBar.resignFirstResponder()
        // Present stock details for given selection
        let vc = StockDetailViewController()
        let naviVC = UINavigationController(rootViewController: vc)
        vc.title = searchResult.description
        present(naviVC, animated: true)
    }
}

// MARK: - extension FloatingPanelControllerDelegate
extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        if fpc.state == .full {
            navigationItem.titleView?.isHidden = true
        } else if fpc.state != .full {
            navigationItem.titleView?.isHidden = false
        }
    }
}

// MARK: - extension UITableViewDelegate, UITableViewDataSource
extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Open details for selection
    }
}
