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
    
    struct DynamicCodingsKeys: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
        
        // safer initializer with fallback
        static func makeKey(stringValue: String) -> DynamicCodingsKeys {
            return DynamicCodingsKeys(stringValue: stringValue) ?? DynamicCodingsKeys(stringValue: "unknown value")!
        }
    }
    
    // decode the API - in form of JSON via decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingsKeys.self)
        idMeal = try container.decode(String.self, forKey: .makeKey(stringValue: "idMeal"))
        strMeal = try container.decode(String.self, forKey: .makeKey(stringValue: "strMeal"))
        strCategory = try container.decode(String.self, forKey: .makeKey(stringValue: "strCategory"))
        strArea = try container.decode(String.self, forKey: .makeKey(stringValue: "strArea"))
        strInstructions = try container.decode(String.self, forKey: .makeKey(stringValue: "strInstructions"))
        strMealThumb = try container.decode(String.self, forKey: .makeKey(stringValue: "strMealThumb"))
        strYoutube = try container.decode(String.self, forKey: .makeKey(stringValue: "strYoutube"))
        
        var ingredients: [String] = []
        var measures: [String] = []
        
        for index in 1...20 {
            if let ingredientKey = DynamicCodingsKeys(stringValue: "strIngredient\(index)"),
               let ingredient = try? container.decodeIfPresent(String.self, forKey: ingredientKey) {
                !ingredient.isEmpty ? ingredients.append(ingredient) : ()
            }
            
            if let measureKey = DynamicCodingsKeys(stringValue: "strMeasure\(index)"),
               let measure = try? container.decodeIfPresent(String.self, forKey: measureKey) {
                !measure.isEmpty ? measures.append(measure) : ()
            }
        }
        
        strIngredients = ingredients
        strMeasures = measures
    }
}

struct MealsResponse: Codable {
    let meals: [Meal]?
}
