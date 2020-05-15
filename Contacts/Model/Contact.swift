//
//  Contact.swift
//  Contacts
//
//  Created by Bryce Bradshaw on 5/15/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    
    var name: String
    var phoneNumber: String
    var emailAddress: String
    var recordID: CKRecord.ID
    
    init(name: String, phoneNumber: String, emailAddress: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID(completion: @escaping ()))
    
}
