//
//  ContactError.swift
//  Contacts
//
//  Created by Bryce Bradshaw on 5/15/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import Foundation

enum ContactError: LocalizedError {
    
    case ckError(Error)
    case couldNotUnwrap
    case unexpectedRecordsFound
    case noUserFound
    case unableToEdit
    
    var errorDescription: String {
        switch self {
            
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get contacts when unwrapping."
        case .unexpectedRecordsFound:
            return "Unexpected records were returned when trying to delete."
        case .noUserFound:
            return "We were unable to find a user."
        case .unableToEdit:
            return "You are not able to edit this post."
        }
    }
}
