//
//  HoldingTableViewCell.swift
//  DeepakMaheshwariDemo
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import UIKit

final class HoldingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "HoldingTableViewCell"
    
    // MARK: - UI Components
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ltpTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.UIStrings.HoldingsCell.ltp
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ltpValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.UIStrings.HoldingsCell.netQuantity
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pnlTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.UIStrings.HoldingsCell.pnl
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pnlValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .tableBackground
        selectionStyle = .none
        
        contentView.addSubview(symbolLabel)
        contentView.addSubview(ltpTitleLabel)
        contentView.addSubview(ltpValueLabel)
        contentView.addSubview(quantityTitleLabel)
        contentView.addSubview(quantityValueLabel)
        contentView.addSubview(pnlTitleLabel)
        contentView.addSubview(pnlValueLabel)
        contentView.addSubview(separatorLine)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            ltpValueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            ltpValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ltpTitleLabel.centerYAnchor.constraint(equalTo: ltpValueLabel.centerYAnchor),
            ltpTitleLabel.trailingAnchor.constraint(equalTo: ltpValueLabel.leadingAnchor, constant: -4),
            
            quantityValueLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 8),
            quantityValueLabel.leadingAnchor.constraint(equalTo: quantityTitleLabel.trailingAnchor, constant: 4),
            quantityValueLabel.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -16),
            
            quantityTitleLabel.centerYAnchor.constraint(equalTo: quantityValueLabel.centerYAnchor),
            quantityTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            pnlValueLabel.topAnchor.constraint(equalTo: ltpValueLabel.bottomAnchor, constant: 8),
            pnlValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pnlValueLabel.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -16),
            
            pnlTitleLabel.centerYAnchor.constraint(equalTo: pnlValueLabel.centerYAnchor),
            pnlTitleLabel.trailingAnchor.constraint(equalTo: pnlValueLabel.leadingAnchor, constant: -4),
            
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Configuration
    func configure(with viewModel: HoldingCellViewModel) {
        symbolLabel.text = viewModel.symbol
        ltpValueLabel.text = viewModel.ltp
        quantityValueLabel.text = viewModel.quantity
        pnlValueLabel.text = viewModel.totalPnL
        pnlValueLabel.textColor = viewModel.isPnLPositive ? UIColor.profitGreen : UIColor.lossRed
    }
    
    func setIsLastCell(_ isLast: Bool) {
        separatorLine.isHidden = isLast
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        ltpValueLabel.text = nil
        quantityValueLabel.text = nil
        pnlValueLabel.text = nil
        separatorLine.isHidden = false
    }
}
