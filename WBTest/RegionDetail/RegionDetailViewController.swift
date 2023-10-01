//
//  RegionDetailViewController.swift
//  WBTest
//
//  Created by Al Stark on 30.09.2023.
//

import UIKit

final class RegionDetailViewController: UIViewController {
    
    private var actions: [String: () -> Void] = [:]
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "title"
        return label
    }()
    
    private lazy var viewsCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "Количество просмотров: "
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
    
    var viewModel: RegionTableCellViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImage()
        setupTitle()
        setupLikeButton()
        setupViewsCount()
    }
    
    deinit {
        viewModel?.isLiked.unbind("RegionDetailViewController")
    }
    
    @objc
    private func likeTapped() {
        actions["likeButton"]?()
    }
    
    func configure(region: RegionTableCellViewModel) {
        self.titleLabel.text = region.title
        self.viewsCountLabel.text = region.viewsCountString
        self.viewModel = region
        actions["likeButton"] = region.onTap
        likeButton.backgroundColor = region.isLiked.value ?? false ? .green : .red
        self.likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
            
        
        region.isLiked.bind("RegionDetailViewController") { [weak self] isLiked in
            guard let self = self else {
                return
            }
            self.likeButton.backgroundColor = isLiked ?? false ? UIColor.green : UIColor.red
        }
        
        if let url = region.imageUrl {
            mainImageView.kf.setImage(with: url)
        } else {
            mainImageView.image = nil
        }
    }
    
    func setupImage() {
        view.addSubview(mainImageView)

        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mainImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor).isActive = true
    }
    
    func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 24).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
    
    private func setupLikeButton() {
        view.addSubview(likeButton)
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        likeButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24).isActive = true
    }
    
    func setupViewsCount() {
        view.addSubview(viewsCountLabel)
        viewsCountLabel.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: 0).isActive = true
        viewsCountLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 24).isActive = true
        viewsCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
}
