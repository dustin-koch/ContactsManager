//
//  Contact.swift
//  ContactsManager
//
//  Created by Dustin Koch on 6/7/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    //MARK: - Properties
    var name: String
    var phoneNumber: String
    var emailAddress: String
    //MARK: - CloudKit Properties
    let ckRecordID: CKRecord.ID
    
    //MARK: - Designated Initializer
    init(name: String, phoneNumber: String, emailAddress: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.ckRecordID = ckRecordID
    }
    
    //MARK: Convenience Initializer (creating Contact with CKRecord)
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Constants.nameKey] as? String,
            let phoneNumber = ckRecord[Constants.phoneNumberKey] as? String,
            let emailAddress = ckRecord[Constants.emailAddressKey] as? String else { return nil }
        
        self.init(name: name, phoneNumber: phoneNumber, emailAddress: emailAddress, ckRecordID: ckRecord.recordID)
    }
    
}//END OF CLASS

//MARK: - Convenience Initializer (creating CKRecord from Contact)
extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: Constants.contactRecordType, recordID: contact.ckRecordID)
        setValue(contact.name, forKey: Constants.nameKey)
        setValue(contact.emailAddress, forKey: Constants.emailAddressKey)
        setValue(contact.phoneNumber, forKey: Constants.phoneNumberKey)
    }
}

//Constants for keys
struct Constants {
    static let contactRecordType = "Contact"
    static let nameKey = "name"
    static let phoneNumberKey = "phoneNumber"
    static let emailAddressKey = "emailAddress"
}
