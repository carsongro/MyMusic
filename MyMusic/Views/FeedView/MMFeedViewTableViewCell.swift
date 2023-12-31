//
//  MMFeedViewTableViewCell.swift
//  MyMusic
//
//  Created by Carson Gross on 8/24/23.
//

import UIKit

class MMFeedViewTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static let cellIdentifier = "MMFeedViewTableViewCell"
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .medium)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .light)
        return label
    }()
    
    private let trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(trackImageView, trackNameLabel, artistNameLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        trackImageView.image = nil
    }
    
    // MARK: Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            artistNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            artistNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            artistNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 10),
            
            trackNameLabel.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor),
            trackNameLabel.leftAnchor.constraint(equalTo: artistNameLabel.leftAnchor),
            trackNameLabel.rightAnchor.constraint(equalTo: artistNameLabel.rightAnchor),
            
            trackImageView.widthAnchor.constraint(equalTo: widthAnchor),
            trackImageView.heightAnchor.constraint(equalTo: widthAnchor),
            trackImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            trackImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: Public
    
    public func configure(with viewModel: MMFeedViewTableViewCellViewModel) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        
        Task { [weak self] in
            do {
                let image = try await viewModel.fetchImage()
                Task { @MainActor in
                    self?.trackImageView.image = image
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
