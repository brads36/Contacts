//
//  ContactListTableViewController.swift
//  Contacts
//
//  Created by Bryce Bradshaw on 5/15/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }

    // MARK: - Class Methods
    func loadData() {
        ContactController.shared.fetchAllContacts { (result) in
            switch result {
            case .success(let contacts):
                guard let contacts = contacts else { return }
                ContactController.shared.contacts = contacts
                self.updateViews()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNumber

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contactToDelete = ContactController.shared.contacts[indexPath.row]
            guard let index = ContactController.shared.contacts.firstIndex(of: contactToDelete)
                else { return }
            ContactController.shared.deleteContact(contactToDelete) { (result) in
                switch result {
                case .success(_):
                    ContactController.shared.contacts.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addContactDetailVC" {
            guard let destinationVC = segue.destination as? ContactDetailViewController else { return }
        }
        
        if segue.identifier == "editContactDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ContactDetailViewController else { return }
            let contactToSend = ContactController.shared.contacts[indexPath.row]
            destinationVC.contact = contactToSend
        }
    }
}
