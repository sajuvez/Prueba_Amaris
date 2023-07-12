//
//  RecipeTableViewCell.swift
//  Prueba_Amaris
//
//  Created by Wilson Jair Tique Aguja on 10/07/23.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
