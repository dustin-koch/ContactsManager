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

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
}//END OF VIEW CONTROLLER
