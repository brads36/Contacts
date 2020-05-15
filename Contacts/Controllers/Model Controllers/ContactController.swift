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
    func saveContact(name: String, phoneNumber: String, emailAddress: String, completion: @escaping (Result<Contact?, ContactError>)-> Void) {
        
        let contact = Contact(name: name, phoneNumber: phoneNumber, emailAddress: emailAddress)
        let ContactRecord = CKRecord(contact: contact)
        publicDB.save(ContactRecord) { (record, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            guard let record = record,
            let savedContact = Contact(ckRecord: record)
                else { return completion(.failure(.couldNotUnwrap)) }
            print("Saved Contact Successfully")
            completion(.success(savedContact))
        }
    }
    
    func fetchAllContacts(completion: @escaping (Result<[Contact]?, ContactError>)-> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactStrings.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            print("Fetched all Contacts Successfully")
            let contacts = records.compactMap({ Contact(ckRecord: $0) })
            completion(.success(contacts))
        }
        
    }
    
    func updateContact(_ contact: Contact, completion: @escaping (Result<Contact, ContactError>)-> Void) {
        
        let record = CKRecord(contact: contact)
        let operation = CKModifyRecordsOperation(recordsToSave: [record])
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {(records, _, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first,
            let updatedContact = Contact(ckRecord: record)
                else { return completion(.failure(.couldNotUnwrap))}
            completion(.success(updatedContact))
        }
        publicDB.add(operation)
    }
    
    func deleteContact(_ contact: Contact, completion: @escaping (Result<Bool, ContactError>)-> Void) {
        
        let operation = CKModifyRecordsOperation(recordIDsToDelete: [contact.recordID])
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {(records, _, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            if records?.count == 0 {
                print("Contact Deleted Successfully")
                completion(.success(true))
            } else {
                return completion(.failure(.unexpectedRecordsFound))
            }
        }
        publicDB.add(operation)
    }
}
