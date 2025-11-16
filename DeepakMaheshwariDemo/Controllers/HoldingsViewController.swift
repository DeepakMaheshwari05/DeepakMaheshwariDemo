//
//  HoldingsViewController.swift
//  DeepakMaheshwariDemo
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import UIKit

final class HoldingsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: HoldingsViewModel
    private var headerHeightConstraint: NSLayoutConstraint?
    private var tableViewTopConstraint: NSLayoutConstraint?
    
    // MARK: - UI Components
    private lazy var portfolioSummaryHeaderView: PortfolioSummaryHeaderView = {
        let view = PortfolioSummaryHeaderView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .tableBackground
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.register(HoldingTableViewCell.self, forCellReuseIdentifier: HoldingTableViewCell.reuseIdentifier)
        table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .appPrimary
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Error Banner Components
    private lazy var errorBannerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.3).cgColor
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorBannerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [errorBannerLabel, refreshButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let errorBannerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("↻ Refresh", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tintColor = .systemRed
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: HoldingsViewModel = HoldingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupViewModel()
        viewModel.fetchHoldings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = AppConstants.UIStrings.ViewTitles.holdings
        view.backgroundColor = .appBackground
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(portfolioSummaryHeaderView)
        
        errorBannerContainer.addSubview(errorBannerStackView)
        view.addSubview(errorBannerContainer)
        
        configureNavigationBar()
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .appPrimary
    }
    
    private func setupConstraints() {
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        NSLayoutConstraint.activate([
            tableViewTopConstraint!,
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            portfolioSummaryHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            portfolioSummaryHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            portfolioSummaryHeaderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorBannerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            errorBannerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            errorBannerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            errorBannerStackView.topAnchor.constraint(equalTo: errorBannerContainer.topAnchor, constant: 10),
            errorBannerStackView.leadingAnchor.constraint(equalTo: errorBannerContainer.leadingAnchor, constant: 12),
            errorBannerStackView.trailingAnchor.constraint(equalTo: errorBannerContainer.trailingAnchor, constant: -12),
            errorBannerStackView.bottomAnchor.constraint(equalTo: errorBannerContainer.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Actions
    @objc private func refreshButtonTapped() {
        refreshButton.isEnabled = false
        refreshButton.alpha = 0.5
        viewModel.fetchHoldings()
    }
    
    private func showErrorBanner(message: String) {
        errorBannerLabel.text = message
        errorBannerContainer.isHidden = false
        errorBannerContainer.alpha = 0.0
        
        view.layoutIfNeeded()
        
        let bannerHeight = errorBannerContainer.bounds.height + 16
        
        tableViewTopConstraint?.constant = bannerHeight
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.errorBannerContainer.alpha = 1.0
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideErrorBanner() {
        tableViewTopConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.errorBannerContainer.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.errorBannerContainer.isHidden = true
        }
    }
    
    private func updateTableViewInsets() {
        let headerHeight = portfolioSummaryHeaderView.bounds.height
        let bottomInset = headerHeight > 0 ? headerHeight + 8 : 0
        
        tableView.contentInset.bottom = bottomInset
        tableView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
}

// MARK: - HoldingsViewModelDelegate
extension HoldingsViewController: HoldingsViewModelDelegate {
    func didUpdateHoldings() {
        hideErrorBanner()
        portfolioSummaryHeaderView.configure(with: viewModel)
        tableView.reloadData()
        
        refreshButton.isEnabled = true
        refreshButton.alpha = 1.0
        
        view.layoutIfNeeded()
        updateTableViewInsets()
    }
    
    func didLoadFallbackData(error: String) {
        showErrorBanner(message: error)
        portfolioSummaryHeaderView.configure(with: viewModel)
        tableView.reloadData()
        
        refreshButton.isEnabled = true
        refreshButton.alpha = 1.0
        
        view.layoutIfNeeded()
        updateTableViewInsets()
    }
    
    func didStartLoading() {
        activityIndicator.startAnimating()
    }
    
    func didFinishLoading() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UITableViewDataSource
extension HoldingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfHoldings()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HoldingTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? HoldingTableViewCell else {
            return UITableViewCell()
        }
        
        if let cellViewModel = viewModel.cellViewModel(at: indexPath.row) {
            cell.configure(with: cellViewModel)
        }
        
        let isLastRow = indexPath.row == viewModel.numberOfHoldings() - 1
        cell.setIsLastCell(isLastRow)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HoldingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - PortfolioSummaryHeaderViewDelegate
extension HoldingsViewController: PortfolioSummaryHeaderViewDelegate {
    func didToggleExpansion() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.updateTableViewInsets()
        }
    }
}


