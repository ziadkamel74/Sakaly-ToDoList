//
//  PopUpVC.swift
//  Sakaly
//
//  Created by Ziad on 6/23/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit
import TextFieldEffects

protocol sendingToDoDelegate {
    func toDo(_ toDo: inout ToDo)
}

class PopUpVC: UIViewController {

    @IBOutlet weak var dateAndTimeTextField: HoshiTextField!
    @IBOutlet weak var noteContentTextField: HoshiTextField!
    
    let datePicker = UIDatePicker()
    var delegate: sendingToDoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        dateAndTimeTextField.delegate = self
        noteContentTextField.delegate = self
    }
    
    private func setDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneBtn, flexibleSpace, cancelBtn], animated: true)
        
        dateAndTimeTextField.inputAccessoryView = toolbar
        dateAndTimeTextField.inputView = datePicker
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
    }
    
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.timeZone = .none
        dateAndTimeTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc private func cancelPressed() {
        self.view.endEditing(true)
    }
    
    private func isValidContent() -> Bool {
        guard let dateAndTime = dateAndTimeTextField.text, !dateAndTime.isEmpty else {
            showAlert(title: "Date and time required", message: "Please choose date and time for your note", actionTitle: "Ok")
            return false
        }
        guard let content = noteContentTextField.text, !content.isEmpty else {
            showAlert(title: "Content required", message: "Please enter your note content", actionTitle: "Ok")
            return false
        }
        return true
    }
    
    private func saveNote() {
        var toDo = ToDo(content: noteContentTextField.text, dateAndTime: dateAndTimeTextField.text, autoId: nil)
        self.delegate?.toDo(&toDo)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        if isValidContent() {
            saveNote()
        }
    }
    
}

extension PopUpVC: UITextFieldDelegate {
    
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
