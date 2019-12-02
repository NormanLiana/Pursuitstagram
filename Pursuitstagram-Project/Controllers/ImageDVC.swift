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
        label.textColor = #colorLiteral(red: 0.6871127486, green: 0.2351325154, blue: 0.2614696622, alpha: 1)
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 44)
        label.text = "Image Detail"
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageForDVC: UIImageView = {
       let img = UIImageView()
        img.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var avatarImage: UIImageView = {
       let img = UIImageView()
        img.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        img.contentMode = .scaleAspectFit
        img.layer.borderWidth = 1.0
        img.layer.masksToBounds = false
        img.layer.cornerRadius = img.frame.size.height/2
        img.clipsToBounds = true
        return img
    }()
    
    lazy var postedByLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6871127486, green: 0.2351325154, blue: 0.2614696622, alpha: 1)
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 22)
        label.textAlignment = .left
        return label
    }()
    
    lazy var postDateLabel: UILabel = {
       let label = UILabel()
        label.text = "Submitted on: \(selectedPost.dateCreated ?? Date())"
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 18)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6871127486, green: 0.2351325154, blue: 0.2614696622, alpha: 1)
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
        constrainAvatarImage()
        constrainPostedByLabel()
        constrainPostDateLabel()
        getImage()
        getAvatarOfPoster()
    }
    
    // MARK: - Private Methods
    private func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(imageForDVC)
        view.addSubview(avatarImage)
        view.addSubview(postDateLabel)
        view.addSubview(postedByLabel)
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
    
    private func getAvatarOfPoster() {
        FirestoreService.manager.getUserFromPost(creatorID: selectedPost.creatorID) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let user):
                self?.postedByLabel.text = user.userName
                
                if let userPhotoURL = user.photoURL {
                    ImageHelper.shared.getImage(urlStr: userPhotoURL) { [weak self] (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let imageURLFromFIR):
                                self?.avatarImage.image = imageURLFromFIR
                            case.failure(let error):
                                print(error)
                            }
                        }
                    }
                    
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
    
    private func constrainAvatarImage() {
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        [avatarImage.bottomAnchor.constraint(equalTo: imageForDVC.topAnchor), avatarImage.leadingAnchor.constraint(equalTo: imageForDVC.leadingAnchor), avatarImage.widthAnchor.constraint(equalTo: imageForDVC.widthAnchor, multiplier: 0.25), avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor)].forEach({$0.isActive = true})
    }
    
    private func constrainPostedByLabel() {
        postedByLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [postedByLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 15), postedByLabel.bottomAnchor.constraint(equalTo: imageForDVC.topAnchor), postedByLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor), postedByLabel.trailingAnchor.constraint(equalTo: imageForDVC.trailingAnchor)].forEach({$0.isActive = true})
    }
    
    private func constrainPostDateLabel() {
        postDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [postDateLabel.topAnchor.constraint(equalTo: imageForDVC.bottomAnchor, constant: 25), postDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), postDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), postDateLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.045)].forEach({$0.isActive = true})
    }
    

}
