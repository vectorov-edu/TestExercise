//
//  ShortUserDataTableViewCell.swift
//  TestExercise
//
//  Created by Admin on 04.01.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ShortUserDataTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    static let identifier = "shortUserdata"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI(name : String, username : String, phone: String, comment: String){
        self.name.text = name
        self.userName.text = username
        self.phone.text = phone
        self.comment.text = comment
    }
}
