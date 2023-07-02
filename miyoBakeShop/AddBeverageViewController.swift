//
//  AddBeverageViewController.swift
//  miyoBakeShop
//
//  Created by Gokhun Celik on 1.07.2023.
//

import UIKit
import CoreData

class AddBeverageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var beverageImageView: UIImageView!
    @IBOutlet weak var beverageNameTextField: UITextField!
    @IBOutlet weak var beveragePriceTextField: UITextField!
    @IBOutlet weak var addBeverageButton: UIButton!
    
    var choosenBeverage = ""
    var choosenBeverageId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBeverageButton.isHidden = true
        
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        
        view.addGestureRecognizer(gestureRecognizer)
        
        beverageImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(selectImage)
        )
        beverageImageView.addGestureRecognizer(imageTapRecognizer)
        
    }
    
    @IBAction func addBeverage(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBeverage = NSEntityDescription.insertNewObject(
            forEntityName: "Beverage",
            into: context
        )
        
        newBeverage.setValue(
            UUID(),
            forKey: "beverageId"
        )
        
        newBeverage.setValue(
            beverageNameTextField.text!,
            forKey: "beverageName"
        )
        
        if let beveragePrice = Double(beveragePriceTextField.text!) {
            newBeverage.setValue(
                beveragePrice,
                forKey: "beveragePrice"
            )
        }
        
        let beverageImageData = beverageImageView.image?.jpegData(compressionQuality: 0.5)
        
        newBeverage.setValue(
            beverageImageData,
            forKey: "beveragePhoto"
        )
        
        do{
            try context.save()
            print("beverage saved")
        }catch {
            print("eroor in save beverage")
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
            beverageImageView.image = info[.originalImage] as? UIImage
            addBeverageButton.isEnabled = true
            addBeverageButton.isHidden = false
            self.dismiss(animated: true, completion: nil)
    }
    
}
