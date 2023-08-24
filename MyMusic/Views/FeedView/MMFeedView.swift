//
//  MMFeedView.swift
//  MyMusic
//
//  Created by Carson Gross on 8/24/23.
//

import UIKit

class MMFeedView: UIView {
    
    let viewModel = MMFeedViewViewModel()
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isPagingEnabled = true
        table.isHidden = true
        table.alpha = 0
        table.register(MMFeedViewTableViewCell.self,
                       forCellReuseIdentifier: MMFeedViewTableViewCell.cellIdentifier)
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        spinner.startAnimating()
        setupTableView()
        addSubviews(tableView, spinner)
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchSongs()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Private
    
    private func setupTableView() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: MMFeedViewViewModelDelegate

extension MMFeedView: MMFeedViewViewModelDelegate {
    func didFetchInitialSongs() {
        spinner.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
    }
}
