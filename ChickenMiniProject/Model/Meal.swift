//
//  Meal.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 05/12/24.
//

import Foundation

struct Meal: Codable {
    let idMeal: String
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strYoutube: String
    let strIngredients: [String]
    let strMeasures: [String]
    
    enum CodingsKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strCategory
        case strArea
        case strInstructions
        case strMealThumb
        case strYoutube
        case strIngredients
        case strMeasures
    }
    
    // decode the API - in form of JSON via decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingsKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strArea = try container.decode(String.self, forKey: .strArea)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strYoutube = try container.decode(String.self, forKey: .strYoutube)
        
        let rawAPIJSON = try JSONSerialization.jsonObject(with: decoder.singleValueContainer().decode(Data.self)) as! [String: Any]
        var ingredients = [String]()
        var measures = [String]()
        
        for key in rawAPIJSON.keys {
            if key.hasPrefix("strIngredient"), let value = rawAPIJSON[key] as? String, !value.isEmpty {
                ingredients.append(value)
            }
            
            if key.hasPrefix("strMeasure"), let value = rawAPIJSON[key] as? String, !value.isEmpty {
                measures.append(value)
            }
        }
        
        strIngredients = ingredients
        strMeasures = measures
    }
}

struct MealsResponse: Codable {
    let meals: [Meal]
}

