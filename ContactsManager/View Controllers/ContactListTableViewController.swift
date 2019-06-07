//
//  ContactListTableViewController.swift
//  ContactsManager
//
//  Created by Dustin Koch on 6/7/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ContactManager.sharedInstance.fetchAllContacts { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentSimpleInputAlert(title: "Add a new contact", message: "You need their name but other details are optional")
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ContactManager.sharedInstance.contacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = ContactManager.sharedInstance.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        var detailString = ""
        if let phone = contact.phoneNumber {
            detailString += "Phone: \(phone)\n"
        }
        if let email = contact.emailAddress {
            detailString += "Email: \(email)"
        }
        cell.detailTextLabel?.text = detailString

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = ContactManager.sharedInstance.contacts[indexPath.row]
            ContactManager.sharedInstance.deleteContactNamed(contact: contact) { (_) in
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetail" {
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            let destinationVC = segue.destination as? ContactDetailViewController
            let contact = ContactManager.sharedInstance.contacts[index]
            destinationVC?.contact = contact
        }
    }
}//END OF VIEW CONTROLLER

//MARK: - Extension to present alert controller
extension ContactListTableViewController {
    func presentSimpleInputAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Creating two text fields
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter phone number (optional)"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter email (optional)"
        }
        //Create actions
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let postAction = UIAlertAction(title: "Add Contact", style: .default) { (_) in
            guard let name = alertController.textFields?[0].text,
                let phone = alertController.textFields?[1].text,
                let email = alertController.textFields?[2].text,
                !name.isEmpty else { return }
            ContactManager.sharedInstance.createContactWith(name: name, phone: phone, email: email, completion: { (_) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        //Add actions/present
        alertController.addAction(dismissAction)
        alertController.addAction(postAction)
        self.present(alertController, animated: true)
    }
}
