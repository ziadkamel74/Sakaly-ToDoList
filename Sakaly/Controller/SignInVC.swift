//
//  SignInVC.swift
//  Sakaly
//
//  Created by Ziad on 5/18/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        emailTextField.text = ""
        emailTextField.alpha = 0.5
        passwordTextField.text = ""
        passwordTextField.alpha = 0.5
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setUpActivityIndicator() -> UIActivityIndicatorView {
        let ActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        ActivityIndicator.center = view.center
        ActivityIndicator.hidesWhenStopped = true
        return ActivityIndicator
    }
    
    private func isValidData() -> Bool {
        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            return true
        }
        showAlert(title: "Missed data", message: "Please enter all textfields above", actionTitle: "Ok")
        return false
    }
    
    private func logUser(email: String, password: String, completion: @escaping () -> ()) {
        let myActivityIndicator = setUpActivityIndicator()
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard self != nil else { return }
            if let error = error {
                myActivityIndicator.stopAnimating()
                self?.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
            } else {
                myActivityIndicator.stopAnimating()
                completion()
            }
        }
    }
    
    private func goToToDoListVC() {
        let toDoListVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.toDoListVC) as! ToDoListVC
        self.navigationController?.pushViewController(toDoListVC, animated: true)
    }
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        if isValidData() {
            logUser(email: emailTextField.text!, password: passwordTextField.text!) {
                self.goToToDoListVC()
            }
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        if viewControllers[0] is SignUpVC {
            self.navigationController?.popViewController(animated: true)
        } else {
            let signUpVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signUpVC) as! SignUpVC
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
}

extension SignInVC: UITextFieldDelegate {
    
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
