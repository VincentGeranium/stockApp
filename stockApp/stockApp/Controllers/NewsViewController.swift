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
    private var stories: [NewsStroy] = [
        NewsStroy(
            category: "tech",
            datetime: 123,
            headline: "headline",
            id: 0,
            image: "",
            related: "related",
            source: "APPL",
            summary: "summary",
            url: ""
        )
    ]
    
    private let controllerType: ControllerType
    
    let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        // Register cell, Header View
        tableView.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
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
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else { fatalError() }
        
        cell.configure(viewModel: .init(model: stories[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
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
