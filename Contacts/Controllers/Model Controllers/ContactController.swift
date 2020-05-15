//
//  ContactController.swift
//  Contacts
//
//  Created by Bryce Bradshaw on 5/15/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    // MARK: - Singleton
    static let shared = ContactController()
    
    // MARK: - Source Of Truth
    var contacts: [Contact] = []
    
    // MARK: - publicDB
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    func saveContact(name: String, completion: @escaping (Result<Contact?, ContactError>)-> Void) {
        
        //let reference = CKRecord.Reference(record: <#T##CKRecord#>, action: <#T##CKRecord_Reference_Action#>)
    }
    
    func fetchAllContacts(completion: @escaping (Result<[Contact]?, ContactError>)-> Void) {
        
    }
    
    func updateContact(_ contact: Contact, completion: @escaping (Result<Contact, ContactError>)-> Void) {
        
    }
    
    func deleteContact(_ contact: Contact, completion: @escaping (Result<Bool, ContactError>)-> Void) {
        
    }
    
}
