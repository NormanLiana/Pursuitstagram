//
//  ImageDVC.swift
//  Pursuitstagram-Project
//
//  Created by Liana Norman on 11/22/19.
//  Copyright © 2019 Liana Norman. All rights reserved.
//

import UIKit

class ImageDVC: UIViewController {
    
    // MARK: - UI Objects
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPink
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 44)
        label.text = "Image Detail"
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageForDVC: UIImageView = {
       let img = UIImageView()
        img.backgroundColor = .white
        return img
    }()
    
    lazy var postDateLabel: UILabel = {
       let label = UILabel()
        label.text = "Submitted on: \(selectedPost.dateCreated ?? Date())"
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 18)
        label.textAlignment = .center
        label.textColor = .systemPink
        return label
    }()
    
    // MARK: - Properties
    var selectedPost: Post!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVCView()
        addSubViews()
        constrainHeaderLabel()
        constrainImage()
        constrainPostDateLabel()
        getImage()
    }
    
    // MARK: - Private Methods
    private func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(imageForDVC)
        view.addSubview(postDateLabel)
    }
    
    private func setUpVCView() {
        view.backgroundColor = .black
        navigationController?.isNavigationBarHidden = false
    }
    
    private func getImage() {
        ImageHelper.shared.getImage(urlStr: selectedPost.photoURL) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageFromFIR):
                    self?.imageForDVC.image = imageFromFIR
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Constraint Methods
    private func constrainHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45), headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), headerLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)].forEach({$0.isActive = true})
    }
    
    private func constrainImage() {
        imageForDVC.translatesAutoresizingMaskIntoConstraints = false
        
        [imageForDVC.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor), imageForDVC.leadingAnchor.constraint(equalTo: view.leadingAnchor), imageForDVC.trailingAnchor.constraint(equalTo: view.trailingAnchor), imageForDVC.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)].forEach({$0.isActive = true})
    }
    
    private func constrainPostDateLabel() {
        postDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [postDateLabel.topAnchor.constraint(equalTo: imageForDVC.bottomAnchor, constant: 25), postDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), postDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), postDateLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.045)].forEach({$0.isActive = true})
    }
    

}
