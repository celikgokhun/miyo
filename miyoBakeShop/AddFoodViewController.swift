//
//  AddFoodViewController.swift
//  miyoBakeShop
//
//  Created by Gokhun Celik on 1.07.2023.
//

import UIKit
import CoreData

class AddFoodViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodPriceTextField: UITextField!
    @IBOutlet weak var foodSaveButton: UIButton!
    
    
    var choosenFood = ""
    var choosenFoodId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if choosenFood != "" {
            // coreData
            
            foodSaveButton.isHidden = true
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchFoodRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
            
            let idFoodString = choosenFoodId?.uuidString
            
            fetchFoodRequest.predicate = NSPredicate(
                format: "foodId = %@", idFoodString!
            )
            
            fetchFoodRequest.returnsObjectsAsFaults = false
            
            do{
                let foods = try context.fetch(fetchFoodRequest)
                
                if foods.count > 0 {
                    for food in foods as! [NSManagedObject]{
                        if let foodName = food.value(forKey: "foodName") as? String {
                            foodNameTextField.text = foodName
                        }
                        
                        if let foodPrice = food.value(forKey: "foodPrice") as? Double {
                            foodPriceTextField.text = String(foodPrice)
                        }
                        
                        if let foodPhoto = food.value(forKey: "foodPhoto") as? Data {
                            let foodImage = UIImage(data: foodPhoto)
                            foodImageView.image = foodImage
                        }
                    }
                }
            } catch {
                print("error: food details")
            }
            
            
        } else {
            foodSaveButton.isHidden = false
            foodSaveButton.isEnabled = false
            
            foodNameTextField.text = ""
            foodPriceTextField.text = ""
        }
        
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        
        view.addGestureRecognizer(gestureRecognizer)
        
        foodImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(selectImage)
        )
        foodImageView.addGestureRecognizer(imageTapRecognizer)
        
    }
    
    @objc func selectImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(
            picker,
            animated: true,
            completion: nil
        )
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            foodImageView.image = info[.originalImage] as? UIImage
            foodSaveButton.isEnabled = true
            self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func addFoodButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newFood = NSEntityDescription.insertNewObject(
            forEntityName: "Food",
            into: context
        )
        
        newFood.setValue(
            UUID(),
            forKey: "foodId"
        )
        
        newFood.setValue(
            foodNameTextField.text!,
            forKey: "foodName"
        )
        
        if let foodPrice = Double(foodPriceTextField.text!) {
            newFood.setValue(
                foodPrice,
                forKey: "foodPrice"
            )
        }
        
        let foodImageData = foodImageView.image?.jpegData(compressionQuality: 0.5)
        
        newFood.setValue(
            foodImageData,
            forKey: "foodPhoto"
        )
        
        do {
            try context.save()
            print("food saved")
        }catch {
            print("error in save food")
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("newData"),
            object: nil
        )
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
