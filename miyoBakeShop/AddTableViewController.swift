//
//  AddTableViewController.swift
//  miyoBakeShop
//
//  Created by Gokhun Celik on 1.07.2023.
//

import UIKit
import CoreData

class AddTableViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableNameTextField: UITextField!
    @IBOutlet weak var saveTableButton: UIButton!
    
    var choosenTable = ""
    var choosenTableId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        
        view.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTable(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newTable = NSEntityDescription.insertNewObject(
            forEntityName: "Table",
            into: context
        )
        
        newTable.setValue(
            UUID(),
            forKey: "tableId"
        )
        
        newTable.setValue(
            tableNameTextField.text!,
            forKey: "tableName"
        )
        
        do {
            try context.save()
            print("table saved")
        }catch {
            print("error in save table")
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("newData"),
            object: nil
        )
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
}
