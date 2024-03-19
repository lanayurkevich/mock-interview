//
//  ContentView.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 18/03/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isStartButtonTapped = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Mock Interview")
                    .font(.title)
                    .padding(.top, 50)
                
                Text("Mock Interview for Any Position")
                    .font(.headline)
                    .padding(.top, 10)
                
                Spacer()
                
                Button(action: {
                    isStartButtonTapped = true
                }) {
                    NavigationLink {
                        InterviewQuestionsView()
                    } label: {
                        Text("Start")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct InterviewQuestionsView: View {
    @State private var selectedPosition = ""
    @State private var yearsOfExperience = ""
    @State private var generatedQuestions: [String] = []
    @State private var isQuestionsGenerated = false
    @State private var isLoading = false
    @State private var isDisabled = true
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Position")) {
                    TextField("Enter position", text: $selectedPosition)
                        .disableAutocorrection(true) // Disable autocorrection
                }
                
                Section(header: Text("Years of Experience")) {
                    TextField("Enter years of experience", text: $yearsOfExperience)
                        .keyboardType(.numberPad)
                        .disableAutocorrection(true) // Disable autocorrection
                }
            }
            Button("Submit") {
                generateQuestions()
            }
            .buttonStyle(.bordered)
            .disabled(isDisabled || isLoading)
            .padding()
            
            if isQuestionsGenerated {
                Section(header: Text("Generated Questions")) {
                    ForEach(generatedQuestions, id: \.self) { question in
                        Text(question)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Interview Questions")
        .onChange(of: selectedPosition) {
            isDisabled = selectedPosition.isEmpty || yearsOfExperience.isEmpty
        }
        .onChange(of: yearsOfExperience) {
            isDisabled = selectedPosition.isEmpty || yearsOfExperience.isEmpty
        }
    }
    
    func generateQuestions() {
        isLoading = true
        
        let apiKey = "OpenAI API"
        let endpoint = "https://api.openai.com/v1/chat/completions"
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
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
            return
        }
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }
            
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("Response data: \(responseString ?? "Unable to decode response data")") // Print response data
            
            do {
                let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.generatedQuestions = response.choices.map { $0.message.content }
                    self.isQuestionsGenerated = true
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    struct OpenAIResponse: Decodable {
        let choices: [Choice]
        
        struct Choice: Decodable {
            let message: Message
            
            struct Message: Decodable {
                let content: String
            }
        }
    }
    
}
