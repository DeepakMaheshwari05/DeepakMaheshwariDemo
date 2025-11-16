//
//  PortfolioSummaryHeaderView.swift
//  DeepakMaheshwariDemo
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import UIKit

protocol PortfolioSummaryHeaderViewDelegate: AnyObject {
    func didToggleExpansion()
}

final class PortfolioSummaryHeaderView: UIView {
    
    // MARK: - Properties
    weak var delegate: PortfolioSummaryHeaderViewDelegate?
    
    private var isExpanded: Bool = false {
        didSet {
            updateExpansionState()
        }
    }
    
    private var expandedHeightConstraint: NSLayoutConstraint?
    private var collapsedHeightConstraint: NSLayoutConstraint?
    
    private var collapsedStackViewConstraints: [NSLayoutConstraint] = []
    private var expandedStackViewConstraints: [NSLayoutConstraint] = []
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collapsedStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let pnlTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.UIStrings.PortfolioSummary.profitAndLoss
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collapsedSpacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let arrowContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let pnlValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expandedStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var currentValueRow: UIStackView = {
        return createRow(title: AppConstants.UIStrings.PortfolioSummary.currentValue, valueLabel: currentValueLabel)
    }()
    
    private let currentValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalInvestmentRow: UIStackView = {
        return createRow(title: AppConstants.UIStrings.PortfolioSummary.totalInvestment, valueLabel: totalInvestmentLabel)
    }()
    
    private let totalInvestmentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var todaysPnLRow: UIStackView = {
        return createRow(title: AppConstants.UIStrings.PortfolioSummary.todaysProfitAndLoss, valueLabel: todaysPnLLabel)
    }()
    
    private let todaysPnLLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPnLTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.UIStrings.PortfolioSummary.profitAndLoss
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expandedSpacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var totalPnLRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(totalPnLTitleLabel)
        
        return stack
    }()
    
    private let topBorderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pnlSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(topBorderLine)
        containerView.addSubview(collapsedStackView)
        containerView.addSubview(expandedStackView)
        
        arrowContainerView.addSubview(arrowImageView)
        collapsedStackView.addArrangedSubview(pnlTitleLabel)
        collapsedStackView.addArrangedSubview(arrowContainerView)
        collapsedStackView.addArrangedSubview(collapsedSpacerView)
        collapsedStackView.addArrangedSubview(pnlValueLabel)
        
        expandedStackView.addArrangedSubview(currentValueRow)
        expandedStackView.addArrangedSubview(totalInvestmentRow)
        expandedStackView.addArrangedSubview(todaysPnLRow)
        expandedStackView.addArrangedSubview(pnlSeparatorLine)
        expandedStackView.addArrangedSubview(totalPnLRow)
        
        setupConstraints()
        setupGestures()
    }
    
    private func setupConstraints() {
        collapsedHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 45)
        expandedHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 180)
        
        collapsedHeightConstraint?.isActive = true
        
        // Common constraints that are always active
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            topBorderLine.topAnchor.constraint(equalTo: containerView.topAnchor),
            topBorderLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topBorderLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            topBorderLine.heightAnchor.constraint(equalToConstant: 1),
            
            arrowContainerView.widthAnchor.constraint(equalToConstant: 20),
            arrowContainerView.heightAnchor.constraint(equalToConstant: 20),
            
            arrowImageView.centerXAnchor.constraint(equalTo: arrowContainerView.centerXAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: arrowContainerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            
            pnlSeparatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // Collapsed state constraints
        collapsedStackViewConstraints = [
            collapsedStackView.topAnchor.constraint(equalTo: topBorderLine.bottomAnchor, constant: 12),
            collapsedStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            collapsedStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            collapsedStackView.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        // Expanded state constraints
        expandedStackViewConstraints = [
            expandedStackView.topAnchor.constraint(equalTo: topBorderLine.bottomAnchor, constant: 12),
            expandedStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            expandedStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            expandedStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ]
        
        // Initially activate only collapsed constraints
        NSLayoutConstraint.activate(collapsedStackViewConstraints)
        expandedStackView.isHidden = true
    }
    
    private func setupGestures() {
        arrowContainerView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(arrowTapped))
        arrowContainerView.addGestureRecognizer(tapGesture)
    }
    
    private func createRow(title: String, valueLabel: UILabel) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = .label
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(valueLabel)
        
        return stack
    }
    
    // MARK: - Actions
    @objc private func arrowTapped() {
        isExpanded.toggle()
        delegate?.didToggleExpansion()
    }
    
    private func updateExpansionState() {
        if isExpanded {
            // Deactivate collapsed constraints, activate expanded constraints
            NSLayoutConstraint.deactivate(collapsedStackViewConstraints)
            NSLayoutConstraint.activate(expandedStackViewConstraints)
            
            expandedStackView.alpha = 0
            expandedStackView.isHidden = false
            
            collapsedHeightConstraint?.isActive = false
            expandedHeightConstraint?.isActive = true
            
            arrowContainerView.removeFromSuperview()
            collapsedSpacerView.removeFromSuperview()
            pnlValueLabel.removeFromSuperview()
            
            totalPnLRow.addArrangedSubview(arrowContainerView)
            totalPnLRow.addArrangedSubview(expandedSpacerView)
            totalPnLRow.addArrangedSubview(pnlValueLabel)
        } else {
            // Deactivate expanded constraints, activate collapsed constraints
            NSLayoutConstraint.deactivate(expandedStackViewConstraints)
            NSLayoutConstraint.activate(collapsedStackViewConstraints)
            
            collapsedStackView.alpha = 0
            collapsedStackView.isHidden = false
            
            expandedHeightConstraint?.isActive = false
            collapsedHeightConstraint?.isActive = true
            
            arrowContainerView.removeFromSuperview()
            expandedSpacerView.removeFromSuperview()
            pnlValueLabel.removeFromSuperview()
            
            collapsedStackView.addArrangedSubview(arrowContainerView)
            collapsedStackView.addArrangedSubview(collapsedSpacerView)
            collapsedStackView.addArrangedSubview(pnlValueLabel)
        }
        
        let animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.85) {
            if self.isExpanded {
                self.collapsedStackView.alpha = 0
                self.expandedStackView.alpha = 1
            } else {
                self.expandedStackView.alpha = 0
                self.collapsedStackView.alpha = 1
            }
            
            self.arrowImageView.transform = self.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            
            self.superview?.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            if position == .end {
                if self.isExpanded {
                    self.collapsedStackView.isHidden = true
                } else {
                    self.expandedStackView.isHidden = true
                }
            }
        }
        
        animator.startAnimation()
    }
    
    // MARK: - Configuration
    func configure(with viewModel: HoldingsViewModel) {
        let pnlText = "\(viewModel.formattedTotalPnL()) \(viewModel.formattedPnLPercentage())"
        pnlValueLabel.text = pnlText
        pnlValueLabel.textColor = viewModel.isPnLPositive() ? .profitGreen : .lossRed
        
        currentValueLabel.text = viewModel.formattedCurrentValue()
        totalInvestmentLabel.text = viewModel.formattedTotalInvestment()
        todaysPnLLabel.text = viewModel.formattedTodaysPnL()
        todaysPnLLabel.textColor = viewModel.isTodaysPnLPositive() ? .profitGreen : .lossRed
    }
}
