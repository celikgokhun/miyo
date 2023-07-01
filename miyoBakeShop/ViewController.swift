//
//  ViewController.swift
//  miyoBakeShop
//
//  Created by Gokhun Celik on 1.07.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var foodListView: UITableView!
    var foodNameArray = [String]()
    var foodIdArray = [UUID]()
    
    var selectedFood = ""
    var selectedFoodId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        foodListView.delegate = self
        foodListView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.add,
            target: self,
            action: #selector(addButtonClicked))
        
        getFoodList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getFoodList),
            name: NSNotification.Name(rawValue: "newData"),
            object: nil
        )
    }
    
    
    @objc func getFoodList() {
        
        foodNameArray.removeAll(keepingCapacity: false)
        foodIdArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchFoodRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        fetchFoodRequest.returnsObjectsAsFaults = false
        
        do{
            let foods = try context.fetch(fetchFoodRequest)
            
            if foods.count > 0 {
                for food in foods as! [NSManagedObject]{
                    
                    if let foodName = food.value(forKey: "foodName") as? String {
                        self.foodNameArray.append(foodName)
                    }
                    
                    
                    if let foodId = food.value(forKey: "foodId") as? UUID {
                        self.foodIdArray.append(foodId)
                    }
                    self.foodListView.reloadData()
                }
            }
        } catch {
            print("error get food list")
        }
        
        
    }
    
    @objc func addButtonClicked() {
        selectedFood = ""
        performSegue(withIdentifier: "toAddFood", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = foodNameArray[indexPath.row]
        return cell
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "toAddFood" {
            let destinationVC = segue.destination as! AddFoodViewController
            destinationVC.choosenFood = selectedFood
            destinationVC.choosenFoodId = selectedFoodId
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        selectedFood = foodNameArray[indexPath.row]
        selectedFoodId = foodIdArray[indexPath.row]
        performSegue(withIdentifier: "toAddFood", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let foodFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
            
            let foodIdString = foodIdArray[indexPath.row].uuidString
            
            foodFetchRequest.predicate = NSPredicate(
                format: "foodId= %@ ",
                foodIdString
            )
            
            foodFetchRequest.returnsObjectsAsFaults = false
            do {
                let foods = try context.fetch(foodFetchRequest)
                if foods.count > 0 {
                    for food in foods as! [NSManagedObject]{
                        if let foodId = food.value(forKey: "foodId") as? UUID {
                            if foodId == foodIdArray[indexPath.row] {
                                context.delete(food)
                                foodNameArray.remove(at: indexPath.row)
                                foodIdArray.remove(at: indexPath.row)
                                self.foodListView.reloadData()
                        
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
                print("error in delete food")
            }
            
        }
    }
    


}

