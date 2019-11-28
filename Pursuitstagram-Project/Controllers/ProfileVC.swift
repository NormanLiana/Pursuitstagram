//
//  ProfileVC.swift
//  Pursuitstagram-Project
//
//  Created by Liana Norman on 11/22/19.
//  Copyright © 2019 Liana Norman. All rights reserved.
//

import UIKit
import Photos

class ProfileVC: UIViewController {
    
    // MARK: - UI Objects
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPink
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 44)
        label.text = "Profile"
        label.textAlignment = .center
        return label
    }()
    
    lazy var userProfileImage: UIImageView = {
       let img = UIImageView()
        img.backgroundColor = .darkGray
        return img
    }()
    
    lazy var imagePickerButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(.add, for: .normal)
        button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
        return button
    }()
    
    lazy var displayNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Display Name"
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 24)
        label.textAlignment = .center
        label.textColor = .systemPink
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var emailLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 18)
        label.text = "youremail@email.com"
        label.textAlignment = .center
        label.textColor = .systemPink
        return label
    }()
    
    lazy var logOutButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain , target: self, action: #selector(signOutUser))
        return barButton
    }()
    
    // MARK: - Properties
    var user: AppUser!
    var isCurrentUser = false

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setUpVCView()
        constrainHeaderLabel()
        constrainImageView()
        constrainImgPickerButton()
        constrainDisplayNameLabel()
        constrainEditButton()
        constrainEmailLabel()
    }
    
    // MARK: - ObjC methods
    @objc private func addImagePressed() {
        //MARK: TODO - action sheet with multiple media options
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                switch status {
                case .authorized:
                    self?.presentImagePickerController()
                case .denied:
                    //MARK: TODO - set up more intuitive UI interaction
                    print("Denied photo library permissions")
                default:
                    //MARK: TODO - set up more intuitive UI interaction
                    print("No usable status")
                }
            })
        default:
            presentImagePickerController()
        }
    }
    
    @objc func signOutUser() {
        FirebaseAuthService.manager.signOutUser()
        
        
    }
    
    // MARK: - Private Methods
    private func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(userProfileImage)
        view.addSubview(imagePickerButton)
        view.addSubview(displayNameLabel)
        view.addSubview(editButton)
        view.addSubview(emailLabel)
    }
    
    private func setUpVCView() {
        view.backgroundColor = .black
        navigationItem.rightBarButtonItem = logOutButton
    }
    
    private func presentImagePickerController() {
        DispatchQueue.main.async{
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            imagePickerViewController.mediaTypes = ["public.image"]
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Constraint Methods
    private func constrainHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45), headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), headerLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)].forEach({$0.isActive = true})
    }
    
    private func constrainImageView() {
        userProfileImage.translatesAutoresizingMaskIntoConstraints = false
        
        [userProfileImage.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.33), userProfileImage.widthAnchor.constraint(equalTo: userProfileImage.heightAnchor), userProfileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor), userProfileImage.bottomAnchor.constraint(equalTo: view.centerYAnchor)].forEach({$0.isActive = true})
    }
    
    private func constrainImgPickerButton() {
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        
        [imagePickerButton.topAnchor.constraint(equalTo: userProfileImage.topAnchor), imagePickerButton.trailingAnchor.constraint(equalTo: userProfileImage.trailingAnchor), imagePickerButton.heightAnchor.constraint(equalTo: userProfileImage.heightAnchor, multiplier: 0.2), imagePickerButton.widthAnchor.constraint(equalTo: imagePickerButton.heightAnchor)].forEach({$0.isActive = true})
    }
    
    private func constrainDisplayNameLabel() {
        displayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [displayNameLabel.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 25), displayNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), displayNameLabel.widthAnchor.constraint(equalTo: userProfileImage.widthAnchor), displayNameLabel.heightAnchor.constraint(equalTo: userProfileImage.heightAnchor, multiplier: 0.15)].forEach({$0.isActive = true})
    }
    
    private func constrainEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        [editButton.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 7), editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), editButton.widthAnchor.constraint(equalTo: displayNameLabel.widthAnchor, multiplier: 0.2), editButton.heightAnchor.constraint(equalTo: displayNameLabel.heightAnchor, multiplier: 0.5)].forEach({$0.isActive = true})
    }
    
    private func constrainEmailLabel() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [emailLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), emailLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15)].forEach({$0.isActive = true})
    }

}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
