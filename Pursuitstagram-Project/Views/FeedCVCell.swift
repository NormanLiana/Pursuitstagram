//
//  FeedCVCell.swift
//  Pursuitstagram-Project
//
//  Created by Liana Norman on 11/24/19.
//  Copyright © 2019 Liana Norman. All rights reserved.
//

import UIKit

class FeedCVCell: UICollectionViewCell {
    
    // MARK: - UI Objects
    lazy var imageInFeed: UIImageView = {
       let img = UIImageView()
        img.backgroundColor = .darkGray
        return img
    }()
    
    lazy var postedByLabel: UILabel = {
       let label = UILabel()
        label.text = "Submitted By:"
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 18)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .systemPink
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageInFeed)
        contentView.addSubview(postedByLabel)
        constrainImage()
        constrainLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Contraint Methods
    private func constrainImage() {
        imageInFeed.translatesAutoresizingMaskIntoConstraints = false
        
        [imageInFeed.topAnchor.constraint(equalTo: contentView.topAnchor), imageInFeed.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), imageInFeed.trailingAnchor.constraint(equalTo: contentView.trailingAnchor), imageInFeed.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)].forEach{$0.isActive = true}
    }
    
    private func constrainLabel() {
        postedByLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [postedByLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), postedByLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor), postedByLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor), postedByLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2)].forEach({$0.isActive = true})
    }
}
