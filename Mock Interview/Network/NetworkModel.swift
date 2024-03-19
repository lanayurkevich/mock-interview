//
//  NetworkModel.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 19/03/2024.
//

import Foundation

class NetworkModel {
    
    private let apiKey = "PRIVATE_KEY"
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    public func loadRequest(request: URLRequest, completion: @escaping ([String]) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("Response data: \(responseString ?? "Unable to decode response data")") // Print response data
            
            do {
                let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                DispatchQueue.main.async {
                    let generatedQuestions = response.choices.map { $0.message.content }
                    completion(generatedQuestions)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        .resume()
    }
    
    func makeQuestionsRequest(selectedPosition: String, yearsOfExperience: String) -> URLRequest? {
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-1106",
            "messages": [
                ["role": "user", "content": "As a \(selectedPosition) with \(yearsOfExperience) years of experience, what are three important questions you would ask in an interview for this role?"]
            ],
            "temperature": 0.5,
            "max_tokens": 64,
            "top_p": 1
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Invalid parameters")
            return nil
        }
        
        request.httpBody = httpBody
        
        return request
    }
    
}
