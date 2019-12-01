//
//  ImageUploadVC.swift
//  Pursuitstagram-Project
//
//  Created by Liana Norman on 11/22/19.
//  Copyright © 2019 Liana Norman. All rights reserved.
//

import UIKit
import Photos

class ImageUploadVC: UIViewController {
    
    // MARK: - UI Objects
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPink
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 44)
        label.text = "Upload An Image"
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageToUpload: UIImageView = {
       let img = UIImageView()
        img.backgroundColor = .white
        img.image = self.currentImage
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var imagePickerButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(.add, for: .normal)
        button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
        return button
    }()
    
    lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(uploadButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var currentImage = UIImage(systemName: "photo") {
        didSet {
            imageToUpload.image = currentImage
        }
    }
    private var imageURL: URL? = nil

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setUpVCView()
        constrainTitleLabel()
        constrainImage()
        constrainImgPickerButton()
        constrainUploadButton()
    }
    
    // MARK: - ObjC Methods
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
    
    @objc func uploadButtonPressed() {
        createPostInFIRStore()
        storeImageInFIRStorage()
        
    }
    
    // MARK: - Private Methods
    private func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(imageToUpload)
        view.addSubview(uploadButton)
        view.addSubview(imagePickerButton)
    }
    
    private func setUpVCView() {
        view.backgroundColor = .black
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
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func createPostInFIRStore() {

        guard let photoURL = self.imageURL,
        let user = FirebaseAuthService.manager.currentUser else {return}
        
        let photoURLString = "\(photoURL)"
        
        let newPost = Post(photoURL: photoURLString, creatorID: user.uid)
        FirestoreService.manager.createPost(post: newPost) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("We DIDN'T post!")
                    print(error)
                case .success(()):
                    self.showAlert(with: "Successfully", and: "Posted!")

                }
            }
            
        }
        
    }
    
    private func storeImageInFIRStorage() {
        guard let image = self.currentImage else {
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        FirebaseStorageService.manager.storeImage(image: imageData, completion: { [weak self] (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let url):
                    self?.imageURL = url
                    print("We stored the image!")
                case .failure(let error):
                    print("We DIDN'T store the image!")
                    print(error)
                }
            }
            
        })
//        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Constraint Methods
    private func constrainTitleLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45), headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), headerLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)].forEach({$0.isActive = true})
    }
    
    private func constrainImage() {
        imageToUpload.translatesAutoresizingMaskIntoConstraints = false
        
        [imageToUpload.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor), imageToUpload.centerXAnchor.constraint(equalTo: view.centerXAnchor), imageToUpload.widthAnchor.constraint(equalTo: imageToUpload.heightAnchor), imageToUpload.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.33)].forEach({$0.isActive = true})
    }
    
    private func constrainImgPickerButton() {
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        
        [imagePickerButton.topAnchor.constraint(equalTo: imageToUpload.topAnchor), imagePickerButton.trailingAnchor.constraint(equalTo: imageToUpload.trailingAnchor), imagePickerButton.heightAnchor.constraint(equalTo: imageToUpload.heightAnchor, multiplier: 0.1), imagePickerButton.widthAnchor.constraint(equalTo: imagePickerButton.heightAnchor)].forEach({$0.isActive = true})
    }

    
    private func constrainUploadButton() {
        uploadButton.translatesAutoresizingMaskIntoConstraints = false

        [uploadButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5), uploadButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05), uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)].forEach({$0.isActive = true})
    }


}


extension ImageUploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.currentImage = image
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
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
