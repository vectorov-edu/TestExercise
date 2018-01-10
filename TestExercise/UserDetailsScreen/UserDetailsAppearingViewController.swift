//
//  UserDetailsAppearingViewController.swift
//  TestExercise
//
//  Created by Admin on 10.01.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class UserDetailsAppearingViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    var user : UserDataModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        print("didMove")
    }
    
    func SetUserData(userdata : UserDataModel) {
        user = userdata
        
        name.text = user!.name
        userName.text = user?.username
        phone.text = user?.phone
    }
}
