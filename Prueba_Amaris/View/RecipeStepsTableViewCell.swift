//
//  RecipeStepsTableViewCell.swift
//  Prueba_Amaris
//
//  Created by Wilson Jair Tique Aguja on 10/07/23.
//

import UIKit

class RecipeStepsTableViewCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var stepLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }

}
