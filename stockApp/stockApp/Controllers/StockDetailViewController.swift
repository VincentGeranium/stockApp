//
//  StockDetailViewController.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/15.
//

import Foundation
import UIKit
import SafariServices

class StockDetailViewController: UIViewController {
    // MARK: - Properties
    private let symbol: String
    private let companyName: String
    private var candleStickData: [CandleStick]
    private var stories: [NewsStroy] = []
    private var metrics: Metrics?
    
    let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        tableView.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - init
    init(symbol: String, companyName: String, candleStickData: [CandleStick] = []) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleStickData = candleStickData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = companyName
        
        setupCloseButton()
        
        // Show view
        setupTableView()
        
        // Finalcial Data
        fetchFinancialData()
        
        // Show news
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - Private
extension StockDetailViewController {
    private func setupCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: (view.width * 0.7) + 100)
        )
    }
    
    private func fetchFinancialData() {
        let group = DispatchGroup()
        
        // Fetch Candle sticks if needed
        if candleStickData.isEmpty {
            group.enter()
        }
        
        // Fetch financial metrics
        group.enter()
        APIManager.shared.financialMetrics(for: symbol) { [weak self] result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let response):
                let metrics = response.metric
                self?.metrics = metrics
            case .failure(let error):
                print(error)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.renderChart()
        }
    }
    
    private func fetchNews() {
        APIManager.shared.news(for: .company(symbol: symbol)) { [weak self] result in
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self?.stories = stories
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func renderChart() {
        // Chart ViewModel | Collection of FinancialMetricViewModel(s)
        let headerView = StockDetailHeaderView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: (view.width * 0.7) + 100
            )
        )
        
        headerView.backgroundColor = .link
        
        // Configure
        
        
        var viewModels: [MetricViewModel] = []
        
        if let metrics = metrics {
            viewModels.append(.init(name: "52W High", value: "\(metrics.annualWeekHigh)"))
            viewModels.append(.init(name: "52W Low", value: "\(metrics.annualWeekLow)"))
            viewModels.append(.init(name: "52W Return", value: "\(metrics.annualWeekPriceReturnDaily)"))
            viewModels.append(.init(name: "Beta", value: "\(metrics.beta)"))
            viewModels.append(.init(name: "10D Vol.", value: "\(metrics.tenDayAverageTradingVolume)"))
        }
        
        headerView.configure(
            chartViewModel: .init(
                data: [],
                showLegend: false,
                showAxis: false
            ),
            metricViewModels: viewModels
        )
        
        tableView.tableHeaderView = headerView
    }
}

// MARK: - extension UITableViewDelegate, UITableViewDelegate
extension StockDetailViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else {
            fatalError()
        }
        
        cell.configure(viewModel: .init(model: stories[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
            return nil
        }
        
        header.delegate = self
        header.configure(
            with: .init(
                title: symbol.uppercased(),
                shouldShowAddButton: !PersistenceManager.shared.watchlistContains(symbol: symbol)
            )
        )
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = URL(string: stories[indexPath.row].url) else { return }
        
        let vc = SFSafariViewController(url: url)
        
        present(vc, animated: true)
    }
}

// MARK: - extension NewsHeaderViewDelegate
extension StockDetailViewController: NewsHeaderViewDelegate {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView) {
        // Add to watchlist
        headerView.button.isHidden = true
        
        PersistenceManager.shared.addToWatchList(
            symbol: symbol,
            companyName: companyName
        )
        
        let alertVC = UIAlertController(
            title: "Added to Watchlisth.",
            message: "We've added \(companyName) to your watchlist.",
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alertVC.addAction(alertAction)
        
        present(alertVC, animated: true)
    }
}
