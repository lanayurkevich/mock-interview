//
//  QuestionView.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 19/03/2024.
//

import SwiftUI
import UIKit

struct QuestionView: View {
    
    @Environment(ViewModel.self) private var viewModel: ViewModel// Use @EnvironmentObject for injecting ViewModel
    
    let dismiss: () -> Void
    
    @State private var response: String = "" // State variable to hold the user's response
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if viewModel.state == .feedback {
                    FeedbackView()
                }
                else {
                    VStack {
                    Text(viewModel.question)
                        .padding()
                    
                    TextField("Enter your response", text: $response, onCommit: {
                        // Handle user's response here if needed
                    })
                    .padding()
                        Button("Next") {
                            viewModel.nextStep(response)
                            response = ""
                        }
                    }
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#if DEBUG
struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(dismiss: {})
            .environment(ViewModel()) // Injecting ViewModel as environment object
    }
}
#endif
