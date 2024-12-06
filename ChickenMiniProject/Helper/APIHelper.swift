//
//  APIHelper.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 06/12/24.
//

import UIKit

class APIHelper {
    static let shared = APIHelper()
    
    private init() {}
    
    func fetchMeals(query: String? = nil, completion: @escaping (Result<[Meal], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://www.themealdb.com/api/json/v1/1/search.php") else { print("Invalid URL Components returned")
            return
        }
        
        // provide query parameter, if used/provided
        if let query = query, !query.isEmpty {
            urlComponents.queryItems = [URLQueryItem(name: "s", value: query)]
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
            print("Invalid URL returned")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Error during data fetching: \(error)")
                return
            }
            
            
            guard let data else {
                completion(.failure(NSError(domain: "NoData", code: 404, userInfo: nil)))
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let mealsResponse = try decoder.decode(MealsResponse.self, from: data)
                let meals = mealsResponse.meals
                completion(.success(meals))
                print(meals)
                
                // use data in main thread
                DispatchQueue.main.async {
                    print("Fetched meals: \(meals)")
                }
            } catch {
                completion(.failure(error))
                print("Error during JSON Decoding: \(error)")
            }
        }
        task.resume()
    }
}
