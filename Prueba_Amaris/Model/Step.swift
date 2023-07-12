//
//  Step.swift
//  Prueba_Amaris
//
//  Created by Wilson Jair Tique Aguja on 10/07/23.
//

import Foundation
import SwiftyJSON

class Step {
    var stepNo: Int
    var name: String

    init(json: JSON) {
        self.stepNo = json["number"].intValue
        self.name = json["step"].stringValue
    }
}
