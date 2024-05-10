//
//  FeedbackView.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 16/04/2024.
//

import SwiftUI

struct FeedbackView: View {
    
    let yearsOfExperience: String
    let selectedPosition: String

    @Environment(ViewModel.self) private var viewModel: ViewModel
    @State private var finalFeedback: String = "Loading..."
    @State private var showFeedback = false
    @State private var isLoading = true

    private let network = NetworkModel()

    var body: some View {
        ScrollView{
            if showFeedback {
                Text(finalFeedback)
                    .padding()
                if isLoading {
                    Image(.sandClock)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                }
            } else {
                VStack(alignment: .leading) {
                    Group {
                        Text(viewModel.questions[0])
                        Text(viewModel.answers[0]).bold()
                        Divider()
                        Text(viewModel.questions[1])
                        Text(viewModel.answers[1]).bold()
                        Divider()
                        Text(viewModel.questions[2])
                        Text(viewModel.answers[2]).bold()
                    }
                    .padding()
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .leading) {
                            Button("Start Again", role: .destructive) {
                                viewModel.reset()
                            }
                            Button("Submit") {
                                viewModel.title = "Feedback"
                                showFeedback = true
                                submit()
                            }
                            .buttonStyle(.bordered)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 16)
                }
            }
        }
    }

    func submit() {
        guard let request = network.provideFeedback(selectedPosition: selectedPosition, yearsOfExperience: yearsOfExperience, questions: viewModel.questions, answers: viewModel.answers) else {
            return
        }
        network.fetchFeedback(request: request) { response in
            DispatchQueue.main.async {
                print("FEEDBACK \(response)")
                finalFeedback = response
                isLoading = false
            }
        }
    }
}
