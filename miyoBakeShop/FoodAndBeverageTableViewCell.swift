//
//  FoodAndBeverageTableViewCell.swift
//  miyoBakeShop
//
//  Created by Gokhun Celik on 2.07.2023.
//

import UIKit

class FoodAndBeverageTableViewCell: UITableViewCell {

    @IBOutlet weak var FoodOrBeverageImageView: UIImageView!
    @IBOutlet weak var FoodOrBeverageNameLabel: UILabel!
    @IBOutlet weak var FoodOrBeveagePriceLabel: UILabel!
    
    
    @IBOutlet weak var FoodOrBeveageAmountLabel: UILabel!
    @IBOutlet weak var MinusButton: UIButton!
    @IBOutlet weak var PlusButton: UIButton!
    
    var amount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func minusButtonClick(_ sender: Any) {
        if amount > 0 {
                amount = amount - 1
            
                FoodOrBeveageAmountLabel.text = String(amount)
            }
        
        if amount == 0 {
            MinusButton.isEnabled = false
        } else {
            MinusButton.isEnabled = true
        }
    
    }
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        amount = amount + 1
        FoodOrBeveageAmountLabel.text = String(amount)
        
        if amount == 0 {
            MinusButton.isEnabled = false
        } else {
            MinusButton.isEnabled = true
        }
    }
    
    func cellInit (
        name: String,
        price: Double,
        amount: Int,
        photo:Data
    ) {
        
        FoodOrBeverageNameLabel.text = name
        FoodOrBeveagePriceLabel.text = String(price) + "TL"
        FoodOrBeveageAmountLabel.text = String(amount)
        
        let image = UIImage(data: photo)
        FoodOrBeverageImageView.image = image
        
        MinusButton.isEnabled = false
        
    }
    
}
