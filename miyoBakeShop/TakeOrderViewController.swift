//
//  TakeOrderViewController.swift
//  miyoBakeShop
//
//  Created by Gokhun Celik on 1.07.2023.
//

import UIKit
import CoreData

class TakeOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var choosenTable = ""
    var choosenTableId: UUID?
    
    var selectedItem = "foods"
    
    @IBOutlet weak var foodAndBeverageTableView: UITableView!
    
    @IBOutlet weak var addFoodOrBeverage: UIButton!
    @IBOutlet weak var foodAndBeveragesSegmentController: UISegmentedControl!
    
    var foodIdArray = [UUID]()
    var foodNameArray = [String]()
    var foodPriceArray = [Double]()
    var foodPhotoArray = [Data]()
    
    var beverageIdArray = [UUID]()
    var beverageNameArray = [String]()
    var beveragePriceArray = [Double]()
    var beveragePhotoArray = [Data]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        foodAndBeverageTableView.delegate = self
        foodAndBeverageTableView.dataSource = self
    
        
        foodAndBeveragesSegmentController
            .addTarget(
                self,
                action: #selector(segmentedControlValueChanged),
                for: .valueChanged
            )
        
        getFoodList()
        getBeverageList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    @objc func getFoodList(){
        
        foodIdArray.removeAll(keepingCapacity: false)
        foodNameArray.removeAll(keepingCapacity: false)
        foodPriceArray.removeAll(keepingCapacity: false)
        foodPhotoArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchFoodRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        fetchFoodRequest.returnsObjectsAsFaults = false
        
        do{
            let foods =  try context.fetch(fetchFoodRequest)
            
            if foods.count > 0 {
                for food in foods as! [NSManagedObject]{
                    
                    if let foodId = food.value(forKey: "foodId") as? UUID {
                        self.foodIdArray.append(foodId)
                    }
                    
                    if let foodName = food.value(forKey: "foodName") as? String {
                        self.foodNameArray.append(foodName)
                    }
                    
                    if let foodPrice = food.value(forKey: "foodPrice") as? Double {
                        self.foodPriceArray.append(foodPrice)
                    }
                    
                    if let foodPhoto = food.value(forKey: "foodPhoto") as? Data {
                        self.foodPhotoArray.append(foodPhoto)
                    }
                    self.foodAndBeverageTableView.reloadData()
                }
            }
        } catch {
            print("error get table list")
        }
        
    }
    
    @objc func getBeverageList(){
        
        beverageIdArray.removeAll(keepingCapacity: false)
        beverageNameArray.removeAll(keepingCapacity: false)
        beveragePriceArray.removeAll(keepingCapacity: false)
        beveragePhotoArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchBeverageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Beverage")
        fetchBeverageRequest.returnsObjectsAsFaults = false
        
        do{
            let beverages =  try context.fetch(fetchBeverageRequest)
            
            if beverages.count > 0 {
                for beverage in beverages as! [NSManagedObject]{
                    
                    if let beverageId = beverage.value(forKey: "beverageId") as? UUID {
                        self.beverageIdArray.append(beverageId)
                    }
                    
                    if let beverageName = beverage.value(forKey: "beverageName") as? String {
                        self.beverageNameArray.append(beverageName)
                    }
                    
                    if let beveragePrice = beverage.value(forKey: "beveragePrice") as? Double {
                        self.beveragePriceArray.append(beveragePrice)
                    }
                    
                    if let beveragePhoto = beverage.value(forKey: "beveragePhoto") as? Data {
                        self.beveragePhotoArray.append(beveragePhoto)
                    }
                    
                    self.foodAndBeverageTableView.reloadData()
                        
                }
            }
        } catch {
            print("error get table list")
        }
        
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        
        if(selectedSegmentIndex == 0) {
            selectedItem = "foods"
        } else {
            selectedItem = "beverages"
        }
    }
    
    @IBAction func toDirectAddingFoodOrBeverage(_ sender: Any) {
        if(selectedItem == "foods") {
            performSegue(withIdentifier: "toAddFood", sender: nil)
        } else {
            performSegue(withIdentifier: "toAddBeverage", sender: nil)
        }
        
        if selectedItem == "foods" {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(getFoodList),
                name: NSNotification.Name(rawValue: "newData"),
                object: nil
            )
        } else {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(getBeverageList),
                name: NSNotification.Name(rawValue: "newData"),
                object: nil
            )
        }
            
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowNumber: Int = foodIdArray.count
        if(selectedItem == "foods") {
            rowNumber = foodIdArray.count
        } else {
            rowNumber = beverageIdArray.count
        }
        return rowNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if(selectedItem == "foods") {
            
            print(foodNameArray[indexPath.row])
            
            if let foodImage = foodPhotoArray[indexPath.row] as? Data {
                let foodImage = UIImage(data: foodImage)
                cell.imageView?.image = foodImage
            }
            
            cell.textLabel?.text = foodNameArray[indexPath.row]
            
            let foodPrice = String(foodPriceArray[indexPath.row])
            cell.textLabel?.text = foodPrice
            
        } else {
            
            if let beverageImage = beveragePhotoArray[indexPath.row] as? Data {
                let beverageImage = UIImage(data: beverageImage)
                cell.imageView?.image = beverageImage
            }
            
            cell.textLabel?.text = beverageNameArray[indexPath.row]
            
            let beveragePrice = String(beveragePriceArray[indexPath.row])
            cell.textLabel?.text = beveragePrice
        }
  
        return cell
    }
    

}
