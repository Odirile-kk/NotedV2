//
//  TaskTableViewController.swift
//  NotedApp
//
//  Created by Odirile Kekana on 2021/09/19.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController, TaskTableViewCellDelegate, SaveTasks, LoadTasks {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   // private var models = [CompEntity]()
    
    var taskArray: [Task] = []
    
    var taskss: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTasks()
    }
    

    //try if else statements
    func checkBoxToggle(sender: TaskTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            taskArray[selectedIndexPath.row].completed = !taskArray[selectedIndexPath.row].completed
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveTasks()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.tasks = taskArray[selectedIndexPath.row]
        }
        else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }

    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        //passes data to the next view controllers and allows you to edit 
        let source = segue.source as! DetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            taskArray[selectedIndexPath.row] = source.tasks
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
        else {
            //saves new items that you have added
            let newIndexPath = IndexPath(row: taskArray.count, section: 0)
            taskArray.append(source.tasks)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveTasks()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            taskArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
        saveTasks()
    }
    
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskTableViewCell
        
        cell.delegate = self
        cell.taskLbl.text = taskArray[indexPath.row].name
        cell.descLbl.text = taskArray[indexPath.row].desc
        cell.checkBtn.isSelected = taskArray[indexPath.row].completed
        cell.proBtn.setTitle(taskArray[indexPath.row].priority, for: .normal)

        return cell
    }
    
    
    
    
    
    func saveTasks() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("Task.plist")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(taskArray)
        
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        }
        catch{
            print(error)
        }
        
    }
    
    func loadTasks() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("Task.plist")
        
        guard let data = try? Data(contentsOf: documentURL)
        else {
            return
        }
        let jsonDecoder = JSONDecoder()
        do{
            taskArray = try jsonDecoder.decode(Array<Task>.self, from: data)
        }
        catch {
            print(error)
        }
    }
  
}
