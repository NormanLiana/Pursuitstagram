//
//  FeedVC.swift
//  Pursuitstagram-Project
//
//  Created by Liana Norman on 11/22/19.
//  Copyright © 2019 Liana Norman. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    // MARK: - UI Objects
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPink
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 44)
        label.text = "Feed"
        label.textAlignment = .center
        return label
    }()
    
    lazy var feedCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(FeedCVCell.self, forCellWithReuseIdentifier: "feedCVCell")
        return cv
    }()
    
    lazy var uploadPostButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Post", style: UIBarButtonItem.Style.plain , target: self, action: #selector(segueToImageUploadVC))
        return barButton
    }()
    
    // MARK: - Properties
    var posts = [Post]()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVCView()
        addSubViews()
        delegation()
        constrainHeaderLabel()
        constrainFeedCV()
    }
    
    // MARK: ObjC Methods
    @objc func segueToImageUploadVC() {
        let imgUploadVC = ImageUploadVC()
        navigationController?.pushViewController(imgUploadVC, animated: true)
    }
    
    // MARK: - Private Methods
    private func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(feedCV)
    }
    
    private func setUpVCView() {
        view.backgroundColor = .black
        navigationItem.rightBarButtonItem = uploadPostButton
    }
    
    private func delegation() {
        feedCV.dataSource = self
        feedCV.delegate = self
    }
    
    // MARK: - Constraint Methods
    private func constrainHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45), headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), headerLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)].forEach({$0.isActive = true})
    }
    
    private func constrainFeedCV() {
        feedCV.translatesAutoresizingMaskIntoConstraints = false
        
        [feedCV.topAnchor.constraint(equalTo: headerLabel.bottomAnchor), feedCV.leadingAnchor.constraint(equalTo: view.leadingAnchor), feedCV.trailingAnchor.constraint(equalTo: view.trailingAnchor), feedCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].forEach({$0.isActive = true})
    }

}


extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = feedCV.dequeueReusableCell(withReuseIdentifier: "feedCVCell", for: indexPath) as? FeedCVCell {
            cell.backgroundColor = .darkGray
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
}

extension FeedVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let post = posts[indexPath.row]
        let postDVC = ImageDVC()
//        postDVC.selectedPost = post
        navigationController?.pushViewController(postDVC, animated: true)
    }
}
