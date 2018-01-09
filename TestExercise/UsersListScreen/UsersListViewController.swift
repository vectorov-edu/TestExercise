//
//  ViewController.swift
//  TestExercise
//
//  Created by Admin on 25.12.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Moya
import CoreData

class UsersListViewController: UIViewController {

    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private var request : MoyaProvider<UsersApiService>?
    private var userList : [UserDataModel]?
    private var controller : UserListDataService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = UserListDataService(repo: CoreDataRepository())
        controller?.GetDataForViewController(completion: OnDataReceive)
        
        self.userListTableView.dataSource = self
        self.userListTableView.delegate = self

        userListTableView.register(UINib.init(nibName: "ShortUserDataTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: ShortUserDataTableViewCell.identifier)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserDetail" {
            if let vc = segue.destination as? UserDetailsViewController {
                if let user = sender as? UserDataModel {
                    vc.user = user
                }
            }
        }
    }
    
    func OnDataReceive(data : [UserDataModel] ) {
        userList = data
        reloadTable()
    }
    
    func reloadTable(){
        indicatorView.stopAnimating()
        
        userListTableView.reloadData()
    }

}

extension UsersListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShortUserDataTableViewCell.identifier, for: indexPath) as! ShortUserDataTableViewCell
        
        if let user = userList?[indexPath.row] {
            cell.updateUI(name: user.name!, username: user.username!, phone: user.phone!, comment: user.comment!)
        }
        
        return cell
    }
    
}

extension UsersListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let curUser = userList?[indexPath.item] {
            performSegue(withIdentifier: "toUserDetail", sender: curUser)
        }
    }
}
