//
//  ContentView.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 18/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ViewModel()
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
                            .environment(viewModel)
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
    
    @Environment(ViewModel.self) private var viewModel: ViewModel
    
    @State private var selectedPosition = ""
    @State private var yearsOfExperience = ""
    @State private var generatedQuestions: [String] = []
    @State private var isQuestionsGenerated = false
    @State private var isLoading = false
    @State private var isDisabled = true
    
    private let network = NetworkModel()
    
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
        .onChange(of: isQuestionsGenerated) {
            if isQuestionsGenerated {
                viewModel.state = .question1
            }
        }
        .sheet(isPresented: $isQuestionsGenerated) {
            QuestionView(dismiss: {
                isQuestionsGenerated = false
            })
        }
    }
    
    func generateQuestions() {
        isLoading = true
        
        guard let request = network.makeQuestionsRequest(selectedPosition: selectedPosition, yearsOfExperience: yearsOfExperience) else {
            return
        }
        network.loadRequest(request: request) { response in
            DispatchQueue.main.async {
                self.generatedQuestions = response
                viewModel.questions = response
                viewModel.question = response.first!
                self.isQuestionsGenerated = true
                isLoading = false
            }
        }
    }
}
