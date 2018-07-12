//
//  DocumentsViewController.swift
//  Documents Core Data Relationships Search
//
//  Created by Dale Musser on 7/10/18.
//  Copyright © 2018 Dale Musser. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var documentsTableView: UITableView!
    
    var category: Category?
    var documents = [Document]()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category?.name ?? ""
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDocumentsArray()
        documentsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateDocumentsArray() {
        documents = category?.documents?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as? [Document] ?? [Document]()
    }
    
    // https://cocoacasts.com/core-data-relationships-and-delete-rules
    // Delete rules need to be put in place in the entity editor.
    // When a document is deleted, the document is removed and the associated category remains.
    // On Document entity for category relationship, delete rule is Nullify (if delete 'document', remove it and do not delete the associated category)
    // On Category entity for documents relationship, delete rule is Cascade (if delete 'category', delete the associated documents)
    
    func deleteDocument(at indexPath: IndexPath) {
        let document = documents[indexPath.row]
        
        if let managedObjectContext = document.managedObjectContext {
            managedObjectContext.delete(document)
            
            do {
                try managedObjectContext.save()
                self.documents.remove(at: indexPath.row)
                documentsTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                alertNotifyUser(message: "Delete failed.")
                documentsTableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let cell = cell as? DocumentTableViewCell {
            let document = documents[indexPath.row]
            cell.nameLabel.text = document.name
            cell.sizeLabel.text = String(document.size)
            if let modifiedDate = document.modifiedDate {
                cell.modifiedDateLabel.text = dateFormatter.string(from: modifiedDate)
            } else {
                cell.modifiedDateLabel.text = "unknown"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.deleteDocument(at: indexPath)
        }
        
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentViewController,
            let segueIdentifier = segue.identifier {
            destination.category = category
            if (segueIdentifier == "existingDocument") {
                if let row = documentsTableView.indexPathForSelectedRow?.row {
                    destination.document = documents[row]
                }
            }
        }
    }
    
}
