//
//  RegionTableViewCell.swift
//  WBTest
//
//  Created by Al Stark on 30.09.2023.
//

import UIKit
import Kingfisher

final class RegionTableViewCell: UITableViewCell {
    static var reuseIdentifier = "RegionTableViewCell"
    
    private var actions: [String: () -> Void] = [:]
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "title"
        return label
    }()
    
    private lazy var mainImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .gray
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func likeTapped() {
        actions["likeButton"]?()
    }
    
    func configure(region: RegionTableCellViewModel) {
        self.titleLabel.text = region.title
        actions["likeButton"] = region.onTap
        likeButton.backgroundColor = region.isLiked.value ?? false ? .green : .red
        self.likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        region.isLiked.bind("RegionTableViewCell") { [weak self] isLiked in
            self?.likeButton.backgroundColor = isLiked ?? false ? UIColor.green : UIColor.red
        }
        
        if let url = region.imageUrl {
            mainImageView.kf.setImage(with: url)
        } else {
            mainImageView.image = nil
        }
    }
}

private extension RegionTableViewCell {
    func setupView() {
        setupMainView()
        setupImage()
        setupTitle()
        setupLikeButton()
    }
    
    func setupMainView() {
        contentView.addSubview(mainView)
        mainView.layer.cornerRadius = 8
        mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setupTitle() {
        mainView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -60).isActive = true
    }
    
    func setupLikeButton() {
        mainView.addSubview(likeButton)
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        likeButton.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 0).isActive = true
    }
    
    func setupImage() {
        mainView.addSubview(mainImageView)
        mainImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        mainImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16).isActive = true
        mainImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 24).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -24).isActive = true
    }
}
