//
//  AWSService.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import Foundation

class AWSAPIManager {
    static let baseURL = "https://xau8d9212a.execute-api.us-east-1.amazonaws.com/v2/"
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
    
    static func fetchMenu(for restaurant: Restaurant, user: User, completion: @escaping (Result<MenuResponse, Error>) -> Void) {
        
        guard let url = URL(string: AWSAPIManager.baseURL + "items/\(restaurant.id)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print("Request:", request)
        
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
    
    static func loadReason(for item: MenuItem, user: User, restaurant: Restaurant, completion: @escaping (Result<String, Error>) -> Void) {
        let fitnessGoals = ["Lose Weight", "Maintain Weight", "Gain Weight", "Build Muscle", "Improve Fitness"]
        let fitnessGoal = fitnessGoals.firstIndex(of: user.fitnessGoal) ?? 0
        
        guard let url = URL(string: AWSAPIManager.baseURL + "items/reason/\(restaurant.id)/\(item.id)/\(item.category)/\(fitnessGoal)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print("Request:", request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching reason: \(error?.localizedDescription ?? "Unknown error")")
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code:", httpResponse.statusCode)
                    print("HTTP Headers:", httpResponse.allHeaderFields)
                }
                completion(.failure(error ?? NSError(domain: "Unknown Error", code: 0, userInfo: nil)))
                return
            }
                        
            do {
                struct ResponseWrapper: Decodable {
                    struct ResponseContent: Decodable {
                        let role: String
                        let content: String
                    }
                    let response: ResponseContent
                }

                let jsonResponse = try JSONDecoder().decode(ResponseWrapper.self, from: data)
                let reason = jsonResponse.response.content
                completion(.success(reason))
            } catch {
                print("JSON decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

