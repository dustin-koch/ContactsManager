//
//  ContactManager.swift
//  ContactsManager
//
//  Created by Dustin Koch on 6/7/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation
import CloudKit

class ContactManager {
    
    //MARK: - Singleton
    static let sharedInstance = ContactManager()
    private init () {}
    
    //MARK: - Reference to public database
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //Mark: - Source of truth
    var contacts: [Contact] = []
    
    //MARK: - CRUD functions
    //create contact
    func createContactWith(name: String, phone: String, email: String, completion: @escaping (Bool) -> Void) {
        let newContact = Contact(name: name, phoneNumber: phone, emailAddress: email)
        let newRecord = CKRecord.init(contact: newContact)
        publicDB.save(newRecord) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let record = record else { completion(false); return }
            guard let contact = Contact(ckRecord: record) else { completion(false); return }
            self.contacts.append(contact)
            completion(true)
        }
    }
    //fetch all contacts
    func fetchAllContacts(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.contactRecordType, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let records = records else { completion(false); return }
            let contacts = records.compactMap {Contact(ckRecord: $0)}
            self.contacts = contacts
            completion(true)
        }
    }
    //update contact
    func updateContactNamed(contact: Contact, name: String, phone: String?, email: String?, completion: @escaping (Bool) -> Void) {
        contact.name = name
        contact.phoneNumber = phone
        contact.emailAddress = email
        
        let record = CKRecord(contact: contact)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        operation.completionBlock = {
            completion(true)
        }
        publicDB.add(operation)
    }
    //delete contact
    func deleteContactNamed(contact: Contact, completion: @escaping (Bool) -> Void) {
        let record = CKRecord(contact: contact)
        publicDB.delete(withRecordID: record.recordID) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let index = ContactManager.sharedInstance.contacts.firstIndex(where: {$0.ckRecordID == contact.ckRecordID}) else { completion(false); return}
            self.contacts.remove(at: index)
            completion(true)
        }
    }
}//END OF CLASS
