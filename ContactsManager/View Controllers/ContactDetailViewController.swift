//
//  ContactDetailViewController.swift
//  ContactsManager
//
//  Created by Dustin Koch on 6/7/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: - Landing Pad
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let contact = contact else { return }
        guard let name = nameTextField.text,
            !name.isEmpty else { return }
        let phone = phoneTextField.text
        let email = emailTextField.text
        ContactManager.sharedInstance.updateContactNamed(contact: contact, name: name, phone: phone, email: email) { (_) in
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper functions
    func updateView() {
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        phoneTextField.text = contact.phoneNumber
        emailTextField.text = contact.emailAddress
    }
    
}//END OF VIEW CONTROLLER
