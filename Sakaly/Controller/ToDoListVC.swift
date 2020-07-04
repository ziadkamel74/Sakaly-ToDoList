//
//  ToDoListVC.swift
//  Sakaly
//
//  Created by Ziad on 6/15/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit
import Firebase

class ToDoListVC: UIViewController {
    
    let ref = Database.database().reference()
    var toDoArr: [ToDo] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setUpTableView()
        guard let user = Auth.auth().currentUser else {
            showAlert(title: "Connection error", message: "Please try again", actionTitle: "Ok")
            return
        }
        getData(uid: user.uid)
        self.navigationItem.title = user.displayName
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 54/255, green: 25/255, blue: 79/255, alpha: 1)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setUpTableView() {
        tableView.register(UINib(nibName: Cells.toDoCell, bundle: nil), forCellReuseIdentifier: Cells.toDoCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        self.tableView.tableFooterView = UIView()
    }
    
    private func setUpActivityIndicator() -> UIActivityIndicatorView {
        let ActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        ActivityIndicator.center = view.center
        tableView.backgroundView?.addSubview(ActivityIndicator)
        ActivityIndicator.hidesWhenStopped = true
        return ActivityIndicator
    }
        
    func getData(uid: String) {
        let myActivityIndicator = setUpActivityIndicator()
        myActivityIndicator.startAnimating()
        self.ref.child(uid).observe(.value) { snapshot in
            var tempToDoArr: [ToDo] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot, let dict = childSnapshot.value as? [String : Any], let content = dict[Cells.content] as? String, let dateAndTima = dict[Cells.dateAndTime] as? String {
                    let autoId = childSnapshot.key
                        let toDo = ToDo(content: content, dateAndTime: dateAndTima, autoId: autoId)
                        tempToDoArr.append(toDo)
                }
            }
            self.toDoArr = tempToDoArr
            self.tableView.reloadData()
            myActivityIndicator.stopAnimating()
        }
    }
    
    private func signOut() {
        let signOutAction = UIAlertAction(title: "Sign out", style: .destructive) { action in
            do {
                guard let viewControllers = self.navigationController?.viewControllers else { return }
                if viewControllers.count > 1 {
                    try Auth.auth().signOut()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let signInVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signInVC) as! SignInVC
                    try Auth.auth().signOut()
                    self.navigationController?.pushViewController(signInVC, animated: true)
                }
            } catch {
                self.showAlert(title: "Can't sign out", message: error.localizedDescription, actionTitle: "Ok")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alert = UIAlertController()
        alert.addAction(signOutAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }

    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        signOut()
    }
    
    @IBAction func plusBtnPressed(_ sender: UIBarButtonItem) {
        let popUpVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.popUpVC) as! PopUpVC
        popUpVC.delegate = self
        self.present(popUpVC, animated: true)
    }

}

extension ToDoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.toDoCell, for: indexPath) as? ToDoCell else {
            return UITableViewCell()
        }
        cell.configureCell(toDo: toDoArr[indexPath.row])
        cell.deleteToDoBtnPressed.addTarget(self, action: #selector(deleteCell(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteCell(_ sender: UIButton) {
        let hitPoint = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: hitPoint) else { return }
        let alert = UIAlertController(title: "Sorry", message: "Are you sure you want to delete this todo?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { action in
            guard let user = Auth.auth().currentUser else { return }
            guard let autoId = self.toDoArr[indexPath.row].autoId else { return }
            self.toDoArr.remove(at: indexPath.row)
            self.ref.child(user.uid).child(autoId).removeValue()
            self.tableView.reloadData()
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true)
    }
}

extension ToDoListVC: sendingToDoDelegate {
    
    func toDo(_ toDo: inout ToDo) {
        guard let autoId = ref.childByAutoId().key else { return }
        toDo.autoId = autoId
        self.toDoArr.append(toDo)
        self.tableView.reloadData()
        guard let user = Auth.auth().currentUser else { return }
        self.ref.child(user.uid).child(autoId).setValue([Cells.dateAndTime : toDo.dateAndTime, Cells.content : toDo.content])
    }
    
}
