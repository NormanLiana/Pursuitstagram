//
//  CreateAccountVC.swift
//  Pursuitstagram-Project
//
//  Created by Liana Norman on 11/22/19.
//  Copyright © 2019 Liana Norman. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountVC: UIViewController {
    
    // MARK: - UI Objects
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6871127486, green: 0.2351325154, blue: 0.2614696622, alpha: 1)
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 44)
        label.text = "Create Your Account"
        label.textAlignment = .center
        return label
    }()
    
    lazy var emailTF: UITextField = {
       let tf = UITextField()
        tf.backgroundColor = .white
        tf.textColor = .black
        tf.placeholder = "Email address"
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return tf
    }()
    
    lazy var passwordTF: UITextField = {
       let tf = UITextField()
        tf.backgroundColor = .white
        tf.textColor = .black
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return tf
    }()
    
    lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9571240544, green: 0.598136723, blue: 0.6646113396, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(attemptSignUp), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setUpVCView()
        constrainHeaderLabel()
        constrainEmailTF()
        constrainPasswordTF()
        constrainCreateAccountButton()
    }
    
    private func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(createAccountButton)
    }
    
    private func setUpVCView() {
        view.backgroundColor = .black
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func handleCreateAccountResponse(with result: Result<User, Error>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case.success(let user):
            print(user)
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                    else {
                        //MARK: TODO - handle could not swap root view controller
                        return
                }
                
                if FirebaseAuthService.manager.currentUser != nil {
                    UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                        window.rootViewController = PursuitstagramTBController()
                    }, completion: nil)
                    
                } else {
                    print("No current user")
                }
                
                
            case .failure(let error):
                self?.showAlert(with: "Error Creating User", and: error.localizedDescription)
            }
             
        }
    }
    
    //MARK: - ObjC Methods
    @objc func validateFields() {
        guard emailTF.hasText, passwordTF.hasText else {
            createAccountButton.backgroundColor = #colorLiteral(red: 0.6871127486, green: 0.2351325154, blue: 0.2614696622, alpha: 1)
            createAccountButton.isEnabled = false
            return
        }
        createAccountButton.isEnabled = true
        createAccountButton.backgroundColor = #colorLiteral(red: 0.9571240544, green: 0.598136723, blue: 0.6646113396, alpha: 1)
    }
    
    @objc func attemptSignUp() {
        guard let email = emailTF.text, let password = passwordTF.text else {
            showAlert(with: "Error", and: "Please fill out all fields.")
            return
        }
        
        guard email.isValidEmail else {
            showAlert(with: "Error", and: "Please enter a valid email")
            return
        }
        
        guard password.isValidPassword else {
            showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
            return
        }
        
        FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password) { [weak self] (result) in
            self?.handleCreateAccountResponse(with: result)
        }
    }
    
    // MARK: - Constraint Methods
    private func constrainHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45), headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor), headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor), headerLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)].forEach({$0.isActive = true})
    }
    
    private func constrainEmailTF() {
        emailTF.translatesAutoresizingMaskIntoConstraints = false
        
        [emailTF.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor), emailTF.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor), emailTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8), emailTF.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.04)].forEach({$0.isActive = true})
    }
    
    private func constrainPasswordTF() {
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        
        [passwordTF.widthAnchor.constraint(equalTo: emailTF.widthAnchor), passwordTF.heightAnchor.constraint(equalTo: emailTF.heightAnchor), passwordTF.leadingAnchor.constraint(equalTo: emailTF.leadingAnchor), passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 15)].forEach({$0.isActive = true})
    }
    
    private func constrainCreateAccountButton() {
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        [createAccountButton.widthAnchor.constraint(equalTo: passwordTF.widthAnchor, multiplier: 0.5), createAccountButton.heightAnchor.constraint(equalTo: passwordTF.heightAnchor, multiplier: 1.1), createAccountButton.centerXAnchor.constraint(equalTo: passwordTF.centerXAnchor), createAccountButton.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 10)].forEach({$0.isActive = true})
    }
    


}
