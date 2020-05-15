//
//  Contact.swift
//  Contacts
//
//  Created by Bryce Bradshaw on 5/15/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import Foundation
import CloudKit

struct ContactStrings {
    static let recordTypeKey = "Contact"
    static let nameKey = "name"
    static let phoneNumberKey = "phoneNumber"
    static let emailAddressKey = "emailAddress"
    static let userReferenceKey = "userReference"
}

class Contact {
    
    var name: String
    var phoneNumber: String
    var emailAddress: String
    var recordID: CKRecord.ID
    //var userReference: CKRecord.Reference
    
    init(name: String, phoneNumber: String, emailAddress: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) { //, userReference: CKRecord.Reference) {
        
        self.name = name
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.recordID = recordID
        //self.userReference = userReference
    }
} // End of class
    
// MARK: - Contact Extensions
//Convenience init
extension Contact {
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[ContactStrings.nameKey] as? String,
            let phoneNumber = ckRecord[ContactStrings.phoneNumberKey] as? String,
            let emailAddress = ckRecord[ContactStrings.emailAddressKey] as? String
            //let userReference = ckRecord[ContactStrings.userReferenceKey] as? CKRecord.Reference
            else { return nil }
        
        self.init(name: name, phoneNumber: phoneNumber, emailAddress: emailAddress, recordID: ckRecord.recordID)
        // userReference: userReference)
    }
}

// Equatable extension
extension Contact: Equatable {
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

// MARK: - CKRecord Convenience init Extension
extension CKRecord {
    
    convenience init(contact: Contact) {
        self.init(recordType: ContactStrings.recordTypeKey, recordID: contact.recordID)
        
        self.setValuesForKeys([
            ContactStrings.nameKey : contact.name,
            ContactStrings.phoneNumberKey : contact.phoneNumber,
            ContactStrings.emailAddressKey : contact.emailAddress,
            //ContactStrings.userReferenceKey : contact.userReference
        ])
    }
}
