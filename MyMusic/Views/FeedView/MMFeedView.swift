//
//  MMFeedView.swift
//  MyMusic
//
//  Created by Carson Gross on 8/24/23.
//

import SwiftUI

/// View for the primiary feed
class MMFeedView: UIView {
    
    // MARK: Properties
    
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
    
    var dataSource: UITableViewDiffableDataSource<MMFeedViewViewModel.FeedViewSection, MMFeedViewTableViewCellViewModel>!
    
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
        viewModel.fetchInitialTracks()
        setUpDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Private
    
    private func setupTableView() {
        tableView.delegate = self
    }
    
    private func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView
        ) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self,
                  let cell = tableView.dequeueReusableCell(
                withIdentifier: MMFeedViewTableViewCell.cellIdentifier,
                for: indexPath
            ) as? MMFeedViewTableViewCell else {
                fatalError()
            }
            let cellViewModel = self.viewModel.cellViewModels[indexPath.row]
            cell.configure(with: cellViewModel)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<MMFeedViewViewModel.FeedViewSection, MMFeedViewTableViewCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.cellViewModels)
        dataSource.apply(snapshot, animatingDifferences: false)
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

extension MMFeedView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        frame.size.height - safeAreaInsets.bottom
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.handleCellSelected()
    }
    
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
    func didFetchInitialTracks() {
        spinner.stopAnimating()
        tableView.isHidden = false
        updateDataSource()
        withAnimation {
            self.tableView.alpha = 1
        }
    }
}
