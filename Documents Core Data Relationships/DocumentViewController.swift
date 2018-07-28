//
//  DocumentViewController.swift
//  Documents Core Data Relationships Search
//
//  Created by Dale Musser on 7/10/18.
//  Copyright © 2018 Dale Musser. All rights reserved.
//

import UIKit
import CoreData


class DocumentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var imagePicked: UIImageView!
    var document: Document?
    var category: Category?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
   

        if let document = document {
            let name = document.name
            nameTextField.text = name
            
            contentTextView.text = document.content
            title = name
        }
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
    
    @IBAction func openCameraButton(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("camera not supported by this device")
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
@IBAction func openPhotoLibraryButton(_ sender: Any) {
    guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
        print("can't open photo library")
        return
    }
    /*
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    
    present(imagePicker, animated: true)
*/

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
 
    }
 
  /*  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // get the image
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        // do something with it
        imagePicked.image = image
    }
*/
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImageView {
            imagePicked = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImageView {
            imagePicked = possibleImage
        } else {
            return
        }
 
        // do something interesting here!
      //  print(imagePicked.size)
        
     //   dismiss(animated: true)
        
        /*  let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil) */
    }
    @IBAction func save(_ sender: Any) {
        guard let name = nameTextField.text else {
            alertNotifyUser(message: "Document not saved.\nThe name is not accessible.")
            return
        }
        
        let documentName = name.trimmingCharacters(in: .whitespaces)
        if (documentName == "") {
            alertNotifyUser(message: "Document not saved.\nA name is required.")
            return
        }
        
        let content = contentTextView.text
        
        if document == nil {
            // document doesn't exist, create new one
            if let category = category {
                document = Document(name: documentName, content: content, category: category)
            }
        } else {
            // document exists, update existing one
            if let category = category {
                document?.update(name: documentName, content: content, category: category)
            }
        }
        
        if let document = document {
            do {
                let managedContext = document.managedObjectContext
                try managedContext?.save()
            } catch {
                alertNotifyUser(message: "Document not saved.\nAn error occured saving context.")
            }
        } else {
            alertNotifyUser(message: "Document not saved.\nA Document entity could not be created.")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        title = nameTextField.text
    }
    
}

/*extension DocumentViewController: UI {
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print(info)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
}
*/
