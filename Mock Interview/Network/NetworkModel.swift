//
//  NetworkModel.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 19/03/2024.
//

import Foundation

class NetworkModel {
    
    private let apiKey = ""
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    func loadRequest(request: URLRequest, completion: @escaping ([String]) -> Void) {
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                
                guard let message = response.choices.first?.message.content else {
                    print("No message content found in the response")
                    completion([])
                    return
                }
                
                let generatedQuestions = self.parseQuestions(from: message)
                
                DispatchQueue.main.async {
                    completion(generatedQuestions)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion([])
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
    
    private func parseQuestions(from message: String) -> [String] {
        var questions: [String] = []
        let lines = message.split(separator: "\n").map { String($0) }
        
        for line in lines {
            if line.contains("?") {
                questions.append(line)
            } else if var lastQuestion = questions.last {
                lastQuestion.append(contentsOf: " " + line)
                questions[questions.count - 1] = lastQuestion
            }
        }
        
        return questions
    }
}
