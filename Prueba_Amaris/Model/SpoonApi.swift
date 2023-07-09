//
//  SpoonApi.swift
//  Prueba_Amaris
//
//  Created by Wilson Jair Tique Aguja on 10/07/23.
//

import Foundation
import Alamofire
struct Recipe: Codable {
    let id: Int
    let title: String
    let ingredients: [String]
    let instructions: String
    // Agrega otras propiedades según la estructura de la respuesta JSON
}

class SpoonApi {
    func getDataFromSpoon() {
        
        // Realizar solicitud GET a la API de Spoonacular utilizando Alamofire
              AF.request("https://api.spoonacular.com/recipes").responseDecodable(of: [Recipe].self) { response in
                      if let recipes = response.value {
                          self.recipes = recipes
                          self.tableView.reloadData()
                      }
                  }
    }
    
}
