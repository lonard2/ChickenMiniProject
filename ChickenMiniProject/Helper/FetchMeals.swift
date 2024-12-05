//
//  FetchMeals.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 05/12/24.
//

import UIKit

func fetchMeals() {
    guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error during data fetching: \(error)")
            return
        }
        
        guard let data else {
            print("No data received")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let mealsResponse = try decoder.decode(MealsResponse.self, from: data)
            let meals = mealsResponse.meals
            print(meals)
            
            // use data in main thread
            DispatchQueue.main.async {
                print("Fetched meals: \(meals)")
            }
        } catch {
            print("Error during JSON Decoding: \(error)")
        }
    }
    task.resume()
}
