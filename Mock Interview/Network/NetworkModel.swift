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
    
    func fetchQuestions(request: URLRequest, completion: @escaping ([String]) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
                let lines = message.split(separator: "*").map { String($0) }
                let generatedQuestions = lines

                DispatchQueue.main.async {
                    completion(generatedQuestions)
                }
            } catch {
                print("Error decoding JSON: \(error) \(String(data: data, encoding: .utf8) ?? "")")
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

        guard !apiKey.isEmpty else {
            fatalError("NO API KEY")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-1106",
            "messages": [
                ["role": "user", "content": """

As a \(selectedPosition) with \(yearsOfExperience) years of experience, what are three important questions you would ask in an interview for this role?

Write response in this format and separate every question with a star character (*)

EXAMPLE:

Question one?*Question two?*Question three?*Thank you for your questions.

"""]
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

    func fetchFeedback(request: URLRequest, completion: @escaping (String) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)

                guard let message = response.choices.first?.message.content else {
                    completion("No message content found in the response")
                    return
                }
                completion(message)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(error.localizedDescription)
            }
        }
        .resume()
    }

    func provideFeedback(selectedPosition: String, yearsOfExperience: String, questions: [String], answers: [String]) -> URLRequest? {
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return nil
        }

        guard !apiKey.isEmpty else {
            fatalError("NO API KEY")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-1106",
            "messages": [
                ["role": "user", "content": """

As a \(selectedPosition) with \(yearsOfExperience) years of experience, I have been asked three important questions.

1. \(questions[0])
2. \(questions[1])
3. \(questions[2])

In which I given following answers.

Answer to question 1: \(answers[0])
Answer to question 2: \(answers[1])
Answer to question 3: \(answers[2])

Give me detail analysys for every questions. Here's an example.

Thank you for submitting the form. Open AI checked your answers and here's the feedback.

<Feedback for for the question 1>

<Feedback for for the question 2>

<Feedback for for the question 3>

"""]
            ],
            "temperature": 0.5,
            "max_tokens": 256,
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
