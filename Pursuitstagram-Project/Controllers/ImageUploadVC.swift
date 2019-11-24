//
//  ImageUploadVC.swift
//  Pursuitstagram-Project
//
//  Created by Liana Norman on 11/22/19.
//  Copyright © 2019 Liana Norman. All rights reserved.
//

import UIKit

class ImageUploadVC: UIViewController {
    
    // MARK: - UI Objects
    lazy var titleVCLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPink
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 44)
        label.text = "Upload An Image"
        label.textAlignment = .center
        return label
    }()
    
    lazy var image: UIImageView = {
       let img = UIImageView()
        img.backgroundColor = .white
        return img
    }()
    
    lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setUpVCView()
        constrainTitleLabel()
        constrainImage()
        constrainUploadButton()
    }
    
    // MARK: - Private Methods
    private func addSubViews() {
        view.addSubview(titleVCLabel)
        view.addSubview(image)
        view.addSubview(uploadButton)
    }
    
    private func setUpVCView() {
        view.backgroundColor = .black
    }
    
    // MARK: - Constraint Methods
    private func constrainTitleLabel() {
        titleVCLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [titleVCLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45), titleVCLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), titleVCLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), titleVCLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)].forEach({$0.isActive = true})
    }
    
    private func constrainImage() {
        image.translatesAutoresizingMaskIntoConstraints = false
        
        [image.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor), image.centerXAnchor.constraint(equalTo: view.centerXAnchor), image.widthAnchor.constraint(equalTo: image.heightAnchor), image.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.33)].forEach({$0.isActive = true})
    }
    
    private func constrainUploadButton() {
        uploadButton.translatesAutoresizingMaskIntoConstraints = false

        [uploadButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5), uploadButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05), uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)].forEach({$0.isActive = true})
    }


}