//
//  TasksVC.swift
//  Assignment
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 TheDeveloperEd. All rights reserved.
//

import UIKit

class AssignmentsVC: UITableViewController {
    
    var assignmentService: AssignmentService! {
        didSet {
            assignmentService.assignments = DataService.fetch() ?? [[Assignment](), [Assignment]()]
            tableView.reloadData();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }

    @IBAction func addAssignmentPressed(_ sender: UIBarButtonItem) {
        let newAssignmentAC = UIAlertController(title: "Add new Assignment", message: nil, preferredStyle: .alert)
        
        let addAssignmentAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let assignmentName = newAssignmentAC.textFields?.first?.text else { return }
            let newAssignment = Assignment(name: assignmentName)
            self.assignmentService.add(assignment: newAssignment, index: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        addAssignmentAction.isEnabled = false
        
        let cancelAssignmentAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        newAssignmentAC.addTextField { (textfield) in
            textfield.placeholder = "Enter assignment name"
            textfield.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        
        newAssignmentAC.addAction(addAssignmentAction)
        newAssignmentAC.addAction(cancelAssignmentAction)
        
        present(newAssignmentAC, animated: true)
    }
    
    @objc private func handleTextChanged(sender: UITextField) {
        guard let newAssignmentAC = presentedViewController as? UIAlertController,
            let addAction = newAssignmentAC.actions.first,
            let text = sender.text
        else { return }
        
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return assignmentService.assignments.count
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentService.assignments[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath)
        cell.textLabel?.text = assignmentService.assignments[indexPath.section][indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return section == 0 ? "Backlog" : "Done"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            guard let isDone = self.assignmentService.assignments[indexPath.section][indexPath.row].isDone else { return }
            self.assignmentService.remove(index: indexPath.row, isDone: isDone)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.09803921569, blue: 0.2941176471, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandeler) in
            self.assignmentService.assignments[0][indexPath.row].isDone = true
            let doneAssignment = self.assignmentService.remove(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.assignmentService.add(assignment: doneAssignment, isDone: true, index: 0)
            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            completionHandeler(true)
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.2352941176, green: 0.7058823529, blue: 0.2941176471, alpha: 1)
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
}
