//
//  ToDoCell.swift
//  Sakaly
//
//  Created by Ziad on 6/25/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var deleteToDoBtnPressed: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(toDo: ToDo) {
        dateAndTimeLabel.text = toDo.dateAndTime
        contentLabel.text = toDo.content
    }
    
}
