//
//  Recipe.swift
//  Prueba_Amaris
//
//  Created by Wilson Jair Tique Aguja on 10/07/23.
//

import Foundation
import SwiftyJSON

class Recipe {
    var id: Int
    var name: String
    var image: UIImage?

    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["title"].stringValue
        setImage(from: json["image"].stringValue)
    }

    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else {
                self.image = #imageLiteral(resourceName: "cutlery")
                return }
            let image = UIImage(data: imageData)
            self.image = image
        }
    }
}
