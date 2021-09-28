//
//  TaskTableViewCell.swift
//  NotedApp
//
//  Created by Odirile Kekana on 2021/09/19.
//

import UIKit

protocol  TaskTableViewCellDelegate: Any {
    func checkBoxToggle(sender: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    
    var delegate: TaskTableViewCellDelegate?

    @IBOutlet weak var proBtn: UIButton!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBAction func checkToggled(_ sender: Any) {
        delegate?.checkBoxToggle(sender: self)
    }
    

}
