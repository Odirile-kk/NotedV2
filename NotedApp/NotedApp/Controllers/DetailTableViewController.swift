//
//  DetailTableViewController.swift
//  NotedApp
//
//  Created by Odirile Kekana on 2021/09/19.
//

import UIKit

class DetailTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, SaveTasks {
   
    
  
    @IBOutlet weak var saveBarBtn: UIBarButtonItem!
    @IBOutlet weak var taskText: UITextField!
    @IBOutlet weak var descText: UITextView!
    
    @IBOutlet weak var priorityText: UITextField!
    
    var tasks: Task!
    
    let priorities = ["High", "Medium", "Low"]
    
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if tasks == nil {
            tasks = Task(name: "", desc: "", completed: false, priority: "")
        }
        taskText.text = tasks.name
        descText.text = tasks.desc
        priorityText.text = tasks.priority
        
        pickerView.delegate = self
        pickerView.dataSource = self
        priorityText.inputView = pickerView
        priorityText.textAlignment = .center
        priorityText.placeholder = "Select priority"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityText.text = priorities[row]
        priorityText.resignFirstResponder()
        saveTasks()
    }
    
    //this function will help with editing. Goes with unwindDetail()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tasks = Task(name: taskText.text!, desc: descText.text, completed: tasks.completed, priority: priorityText.text!)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    
    func saveTasks() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("Task.plist")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(tasks)
        
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        }
        catch{
            print(error)
        }
    }
}
