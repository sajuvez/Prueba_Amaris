//
//  SpoonacularApi.swift
//  Prueba_Amaris
//
//  Created by Wilson Jair Tique Aguja on 10/07/23.
//

import Foundation

import Foundation
import Moya
import CoreData

enum SpoonacularAPI {

    case findRecipesByIngredients(ingredients: [Ingredient])
    case getNutritionInformation(dishName: String)
    case getRecipeInformation(id:Int)
    case getRecipesByName(dishName: String)
}

extension SpoonacularAPI: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.spoonacular.com/")!
    }

    var path: String {
        switch self {
        case .findRecipesByIngredients(_):
            return "recipes/findByIngredients"
        case .getNutritionInformation(_):
            return "recipes/guessNutrition"
        case .getRecipeInformation(let id):
            return "recipes/\(id)/analyzedInstructions"
        case .getRecipesByName(_):
        return "recipes/search"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return "".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .findRecipesByIngredients(let ingredients):
            return .requestParameters(parameters:
                [
                    "ingredients": ((ingredients.map({ $0.name! })).joined(separator: ",+")),
                    "apiKey": Spoonacular.apiKey
                ], encoding: URLEncoding.default)
        case .getNutritionInformation(let dishName):
            return .requestParameters(parameters: ["apiKey": Spoonacular.apiKey, "title": dishName], encoding: URLEncoding.default)
        case .getRecipesByName(let dishName):
            return .requestParameters(parameters: ["apiKey": Spoonacular.apiKey, "query": dishName, "number": 10], encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: [ "apiKey": Spoonacular.apiKey ], encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        return nil
    }

}
