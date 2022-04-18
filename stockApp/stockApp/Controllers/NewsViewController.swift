//
//  NewsViewController.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/15.
//

import Foundation
import UIKit

class NewsViewController: UIViewController {
    
    // What type of controller create
    enum ControllerType {
        case topStories
        case company(symbol: String)
        
        // show title in this controller for particular case
        var title: String {
            switch self {
            case .topStories:
                return "Top Stories"
            case .company(let symbol):
                return symbol.uppercased()
            }
        }
    }
    // MARK: - Properties
    // dedicated for model
    private var stories: [String] = []
    
    private let controllerType: ControllerType
    
    let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        // Register cell, Header View
        tableView.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - init
    init(controllerType: ControllerType) {
        self.controllerType = controllerType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // entire size to view
        tableView.frame = view.bounds
    }
}

// MARK: - Private
private extension NewsViewController {
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchNews() {
        
    }
    
    private func open(url: URL) {
        
    }
}

// MARK: - extension UITableViewDelegate, UITableViewDataSource
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else { return UIView() }
        
        headerView.configure(with: .init(title: self.controllerType.title, shouldShowAddButton: false))
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
