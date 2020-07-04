//
//  ViewController.swift
//  Sakaly
//
//  Created by Ziad on 5/13/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passTextField: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        emailTextField.delegate = self
        passTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        nameTextField.text = ""
        nameTextField.alpha = 0.5
        emailTextField.text = ""
        emailTextField.alpha = 0.5
        passTextField.text = ""
        passTextField.alpha = 0.5
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func isValidData() -> Bool {
        if let name = nameTextField.text, !name.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passTextField.text, !password.isEmpty {
            switch email.isValidEmail {
            case true: break
            case false: showAlert(title: "Wrong email", message: "Please enter a valid email", actionTitle: "Ok")
                return false
            }
            switch password.isValidPassword {
            case true: break
            case false: showAlert(title: "Weak password", message: "Make sure password contains minimum 8 characters at least 1 uppercase alphabet, 1 lowercase alphabet, 1 number and 1 special character", actionTitle: "Ok")
                return false
            }
            return true
            }
            showAlert(title: "Missed data", message: "Please enter all textfields above", actionTitle: "Ok")
            return false
    }
    
    private func setUpActivityIndicator() -> UIActivityIndicatorView {
        let ActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        ActivityIndicator.center = view.center
        ActivityIndicator.hidesWhenStopped = true
        return ActivityIndicator
    }
    
    private func createUser(email: String, password: String, name: String, completion: @escaping () -> ()) {
        let myActivityIndicator = setUpActivityIndicator()
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let error = error else {
                if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    currentUser.displayName = name
                    currentUser.commitChanges(completion: { error in
                        guard let error = error else {
                            myActivityIndicator.stopAnimating()
                            completion()
                            return
                        }
                        myActivityIndicator.stopAnimating()
                        self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
                    })
                }
                return
            }
            myActivityIndicator.stopAnimating()
            self.showAlert(title: "Can't sign up", message: error.localizedDescription, actionTitle: "Ok")
        }
    }
    
    private func goToToDoListVC() {
        let toDoListVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.toDoListVC) as! ToDoListVC
        self.navigationController?.pushViewController(toDoListVC, animated: true)
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        if isValidData() {
            createUser(email: emailTextField.text!, password: passTextField.text!, name: nameTextField.text!) {
                self.goToToDoListVC()
            }
            
        }
    }
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        
        guard let viewControllers = self.navigationController?.viewControllers else {return}
        if viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            let signInVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signInVC) as! SignInVC
            self.navigationController?.pushViewController(signInVC, animated: true)
        }
    }
    
}

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.alpha = 1
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            textField.alpha = 0.5
        }
        return true
    }
}

