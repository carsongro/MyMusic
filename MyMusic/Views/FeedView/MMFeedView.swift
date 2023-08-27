//
//  MMFeedView.swift
//  MyMusic
//
//  Created by Carson Gross on 8/24/23.
//

import SwiftUI

class MMFeedView: UIView {
    
    let viewModel = MMFeedViewViewModel()
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isPagingEnabled = true
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.contentInsetAdjustmentBehavior = .never
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
    
    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        spinner.startAnimating()
        setupTableView()
        addSubviews(tableView, spinner)
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchInitialSongs()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Private
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
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

// MARK: TableViewDelegate

extension MMFeedView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MMFeedViewTableViewCell.cellIdentifier,
            for: indexPath
        ) as? MMFeedViewTableViewCell else {
            fatalError()
        }
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        frame.size.height - safeAreaInsets.bottom
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.handleCellSelected()
    }
    
    //TODO: Auto Scroll When Song Ends
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard tableView.visibleCells.count == 1,
              let currentCell = tableView.visibleCells.first as? MMFeedViewTableViewCell,
              currentCell != viewModel.lastDisplayedCell else {
            return
        }
        
        viewModel.displayedCell = currentCell
        viewModel.lastDisplayedCell = viewModel.displayedCell
        viewModel.handleNewDisplayedCell(
            scrollDirection: scrollView.contentOffset.y > viewModel.lastDisplayedCellScrollPosition ? .down : .up
        )
        viewModel.lastDisplayedCellScrollPosition = scrollView.contentOffset.y
    }
}

// MARK: MMFeedViewViewModelDelegate

extension MMFeedView: MMFeedViewViewModelDelegate {
    func didFetchInitialSongs() {
        spinner.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        withAnimation {
            self.tableView.alpha = 1
        }
    }
}
