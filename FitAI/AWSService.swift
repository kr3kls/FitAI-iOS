//
//  AWSService.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import Foundation

class AWSAPIManager {
    static let baseURL = "https://xau8d9212a.execute-api.us-east-1.amazonaws.com/"
}

class AWSRestaurantService {
    
    static func fetchRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        guard let url = URL(string: AWSAPIManager.baseURL + "restaurants") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching restaurants: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                DispatchQueue.main.async {
                    completion(restaurants)
                }
            } catch {
                print("Error decoding restaurants JSON: \(error.localizedDescription)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Data:\n\(jsonString)")
                }
            }
        }.resume()
    }
}

class AWSMenuService {
    
    static func fetchMenu(for restaurantID: Int, user: User, completion: @escaping (Result<MenuResponse, Error>) -> Void) {
        guard let url = URL(string: AWSAPIManager.baseURL + "items/\(restaurantID)") else {
            print("Invalid URL")
            return
        }
        
        let userData: [String: Any] = [
            "age": user.age,
            "height": user.height,
            "weight": user.weight,
            "sex": user.sex,
            "selectedFitnessGoal": user.fitnessGoal
        ]
        
        guard let userData = try? JSONSerialization.data(withJSONObject: userData) else {
            print("Failed to encode user data")
            completion(.failure(NSError(domain: "Encoding Error", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = userData
        
        print("Request:", request)
        if let bodyString = String(data: userData, encoding: .utf8) {
            print("Request Body:", bodyString)
        } else {
            print("Failed to convert body data to string")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching menu: \(error?.localizedDescription ?? "Unknown error")")
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code:", httpResponse.statusCode)
                    print("HTTP Headers:", httpResponse.allHeaderFields)
                }
                completion(.failure(error ?? NSError(domain: "Unknown Error", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let menuItems = try JSONDecoder().decode(MenuResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(menuItems))
                }
            } catch {
                print("Error decoding menu JSON: \(error.localizedDescription)")
                completion(.failure(error))
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Data:\n\(jsonString)")
                }
            }
        }.resume()
    }
}
