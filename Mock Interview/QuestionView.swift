//
//  QuestionView.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 19/03/2024.
//

import SwiftUI
import UIKit

struct QuestionView: View {

    let yearsOfExperience: String
    let selectedPosition: String

    @Environment(ViewModel.self) private var viewModel: ViewModel// Use @EnvironmentObject for injecting ViewModel
    
    let dismiss: () -> Void
    
    @State private var response: String = "" // State variable to hold the user's response

    @AppStorage("response1") private var cacheResponse1 = ""
    @AppStorage("response2") private var cacheResponse2 = ""
    @AppStorage("response3") private var cacheResponse3 = ""

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.state == .validationAndFeedback {
                    FeedbackView(yearsOfExperience: yearsOfExperience, selectedPosition: selectedPosition)
                } else {
                    VStack {
                        Text(viewModel.question)
                            .padding()
                        TextEditor(text: $response)
                            .frame(height: 200)
                        .border(.gray)
                        .padding()

                        Button("Next") {
//                            print("save \(response)")
                            saveResponse()
                            viewModel.nextStep(response)
                            response = ""
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewModel.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear() {
                // Question 1 is initial state.
                getSavedResponses(state: .question1)
            }
            .onChange(of: viewModel.state) { oldValue, newValue in
                getSavedResponses(state: newValue)
            }
        }
    }

    private func getSavedResponses(state: InterviewState) {
        switch state {
        case .question1:
            if !cacheResponse1.isEmpty {
                response = cacheResponse1
            }
        case .question2:
            if !cacheResponse2.isEmpty {
                response = cacheResponse2
            }
        case .question3:
            if !cacheResponse3.isEmpty {
                response = cacheResponse3
            }
        default:
            break
        }
    }

    private func saveResponse() {
        switch viewModel.state {
        case .initial:
            break
        case .question1:
            cacheResponse1 = response
        case .question2:
            cacheResponse2 = response
        case .question3:
            cacheResponse3 = response
        case .validationAndFeedback:
            break
        }
    }


}
