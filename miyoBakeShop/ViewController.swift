//
//  ViewController.swift
//  miyoBakeShop
//
//  Created by Gokhun Celik on 1.07.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableListView: UITableView!
    
    var tableNameArray = [String]()
    var tableIdArray = [UUID]()
    
    var selectedTable = ""
    var selectedTableId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableListView.delegate = self
        tableListView.dataSource = self
    
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.add,
            target: self,
            action: #selector(addButtonClicked))
        
        getTableList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getTableList),
            name: NSNotification.Name(rawValue: "newData"),
            object: nil
        )
    }
    
    
    @objc func getTableList() {
        
        tableNameArray.removeAll(keepingCapacity: false)
        tableIdArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchTableRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Table")
        fetchTableRequest.returnsObjectsAsFaults = false
        
        do{
            let tables = try context.fetch(fetchTableRequest)
            
            if tables.count > 0 {
                for table in tables as! [NSManagedObject]{
                    
                    if let tableName = table.value(forKey: "tableName") as? String {
                        self.tableNameArray.append(tableName)
                    }
                    
                    if let tableId = table.value(forKey: "tableId") as? UUID {
                        self.tableIdArray.append(tableId)
                    }
                    self.tableListView.reloadData()
                }
            }
        } catch {
            print("error get table list")
        }
        
        
    }
    
    @objc func addButtonClicked() {
        selectedTable = ""
        performSegue(withIdentifier: "toAddTable", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tableNameArray[indexPath.row]
        return cell
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "toTakeOrder" {
            let destinationVC = segue.destination as! TakeOrderViewController
            destinationVC.choosenTable = selectedTable
            destinationVC.choosenTableId = selectedTableId
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        selectedTable = tableNameArray[indexPath.row]
        selectedTableId = tableIdArray[indexPath.row]
        performSegue(withIdentifier: "toTakeOrder", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let tableFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Table")
            
            let tableIdString = tableIdArray[indexPath.row].uuidString
            
            tableFetchRequest.predicate = NSPredicate(
                format: "tableId= %@ ",
                tableIdString
            )
            
            tableFetchRequest.returnsObjectsAsFaults = false
            do {
                let tables = try context.fetch(tableFetchRequest)
                if tables.count > 0 {
                    for table in tables as! [NSManagedObject]{
                        if let tableId = table.value(forKey: "tableId") as? UUID {
                            if tableId == tableIdArray[indexPath.row] {
                                context.delete(table)
                                tableNameArray.remove(at: indexPath.row)
                                tableIdArray.remove(at: indexPath.row)
                                self.tableListView.reloadData()
                        
                                do {
                                    try context.save()
                                } catch {
                                    print("error delete and reload")
                                }
                                
                                break
                            }
                        }
                    }
                }
                
            }catch {
                print("error in delete table")
            }
            
        }
    }
    


}

