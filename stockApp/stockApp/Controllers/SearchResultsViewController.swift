//
//  SearchResultsViewController.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/15.
//

import Foundation
import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func SearchResultsViewControllerDidSelect(searchResult: String)
}

class SearchResultsViewController: UIViewController {
    private var results: [String] = []
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        // Register a cell
        tableView.register(
            SearchResultTableViewCell.self,
            forCellReuseIdentifier: SearchResultTableViewCell.identifier
        )
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
    
    // MARK: - Public
    public func update(with results: [String]) {
        self.results = results
        tableView.reloadData()
    }
}

// MARK: - Private
extension SearchResultsViewController {
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - TableViewDelegate and DataSource extension
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        if #available(iOS 14.0, *) {
            var cellConfiguration = cell.defaultContentConfiguration()
            
            cellConfiguration.text = "APPL"
            cellConfiguration.secondaryText = "APPLE.inc"
            
            cell.contentConfiguration = cellConfiguration
            
        } else {
            // Fallback on earlier versions
            cell.textLabel?.text = "APPL"
            cell.detailTextLabel?.text = "APPLE.inc"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.SearchResultsViewControllerDidSelect(searchResult: "APPL")
    }
}
