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
        label.textColor = #colorLiteral(red: 0.6871127486, green: 0.2351325154, blue: 0.2614696622, alpha: 1)
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 44)
        label.text = "Profile"
        label.textAlignment = .center
        return label
    }()
    
    lazy var userProfileImage: UIImageView = {
       let img = UIImageView()
        img.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        img.contentMode = .scaleAspectFit
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
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 24)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6871127486, green: 0.2351325154, blue: 0.2614696622, alpha: 1)
        return label
    }()
    
    lazy var displayNameTF: UITextField = {
       let tf = UITextField()
        tf.backgroundColor = .white
        tf.textColor = .black
        tf.placeholder = "Update display name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6871127486, green: 0.2351325154, blue: 0.2614696622, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        return button
    }()
    
    lazy var emailLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 18)
        label.text = "\(userFIR?.email ?? "youremail@email.com")"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6871127486, green: 0.2351325154, blue: 0.2614696622, alpha: 1)
        return label
    }()
    
    lazy var logOutButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain , target: self, action: #selector(signOutUser))
        return barButton
    }()
    
    // MARK: - Properties
    var user: AppUser!
    var isCurrentUser = false
    var imageURL: URL? = nil
    let userFIR = FirebaseAuthService.manager.currentUser

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setUpVCView()
        constrainHeaderLabel()
        constrainImageView()
        constrainImgPickerButton()
        constrainDisplayNameLabel()
        constrainDisplayNameTF()
        constrainSaveButton()
        constrainEmailLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserProfileImage()
        getUserDisplayName()
    }
    
    // MARK: - ObjC methods
    @objc private func addImagePressed() {
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
    
    @objc func savePressed(){
        guard let userName = displayNameTF.text, let imageURL = imageURL else {
            return
        }
        
        FirebaseAuthService.manager.updateUserProfile(userName: userName, photoURL: imageURL) { (resultForFIRAuth) in
            switch resultForFIRAuth {
            case .success():
                FirestoreService.manager.updateCurrentUser(userName: userName, photoURL: imageURL) { [weak self] (resultForFIRService) in
                    switch resultForFIRService {
                    case .success():
                        self?.displayNameLabel.text = userName
                        self?.displayNameTF.text = ""
                        print("We saved their info")
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @objc func signOutUser() {
        FirebaseAuthService.manager.signOutUser()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
            else {
                //MARK: TODO - handle could not swap root view controller
                return
        }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
           window.rootViewController = LogInVC()
        })
    }
    
    // MARK: - Private Methods
    private func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(userProfileImage)
        view.addSubview(imagePickerButton)
        view.addSubview(displayNameLabel)
        view.addSubview(displayNameTF)
        view.addSubview(saveButton)
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
    
    private func getUserProfileImage() {
        if let userPhotoURL = userFIR?.photoURL {
            ImageHelper.shared.getImage(urlStr: userPhotoURL.description) { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageFromFIR):
                        self?.userProfileImage.image = imageFromFIR
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            userProfileImage.image = UIImage(systemName: "person")
        }
    }
    
    private func getUserDisplayName() {
        if let userDisplayName = user.userName {
            displayNameLabel.text = userDisplayName
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
        
        [imagePickerButton.topAnchor.constraint(equalTo: userProfileImage.topAnchor), imagePickerButton.trailingAnchor.constraint(equalTo: userProfileImage.trailingAnchor), imagePickerButton.heightAnchor.constraint(equalTo: userProfileImage.heightAnchor, multiplier: 0.1), imagePickerButton.widthAnchor.constraint(equalTo: imagePickerButton.heightAnchor)].forEach({$0.isActive = true})
    }
    
    private func constrainDisplayNameLabel() {
        displayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [displayNameLabel.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 25), displayNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), displayNameLabel.widthAnchor.constraint(equalTo: userProfileImage.widthAnchor), displayNameLabel.heightAnchor.constraint(equalTo: userProfileImage.heightAnchor, multiplier: 0.15)].forEach({$0.isActive = true})
    }
    
    private func constrainDisplayNameTF() {
        displayNameTF.translatesAutoresizingMaskIntoConstraints = false
        
        [displayNameTF.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor), displayNameTF.widthAnchor.constraint(equalTo: displayNameLabel.widthAnchor), displayNameTF.heightAnchor.constraint(equalTo: displayNameLabel.heightAnchor), displayNameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach({$0.isActive = true})
    }
    
    private func constrainSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        [saveButton.topAnchor.constraint(equalTo: displayNameTF.bottomAnchor, constant: 7), saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), saveButton.widthAnchor.constraint(equalTo: displayNameTF.widthAnchor, multiplier: 0.5), saveButton.heightAnchor.constraint(equalTo: displayNameTF.heightAnchor, multiplier: 0.75)].forEach({$0.isActive = true})
    }
    
    private func constrainEmailLabel() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [emailLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), emailLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15)].forEach({$0.isActive = true})
    }

}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.editedImage] as? UIImage else {
                return
            }
        self.userProfileImage.image = image
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return
            }
            
            FirebaseStorageService.manager.storeImage(image: imageData, completion: { [weak self] (result) in
                switch result{
                case .success(let url):
                    self?.imageURL = url
                case .failure(let error):
                    print(error)
                }
            })
            dismiss(animated: true, completion: nil)
        }
    
}
