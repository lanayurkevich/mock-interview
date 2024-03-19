//
//  QuestionView.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 19/03/2024.
//

import SwiftUI

struct QuestionView: View {
    
    @Environment(ViewModel.self) private var viewModel: ViewModel
    
    let question: String
    let dismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(question)
                    .padding()
            }
            .navigationTitle(viewModel.state == .question1 ? "Question 1" : "Quesiton 2" )
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Done") { dismiss() }
                }
            }
            .toolbarRole(.navigationStack)
        }
        
    }
}

#Preview {
    QuestionView(question: "1. Can you walk me through a complex iOS project you have worked on and explain the specific challenges you faced and how you overcame them?\n2. How do you stay updated with the latest iOS development trends and technologies, and how do you incorporate them into your work?\n3. Can you provide an example of a", dismiss: {})
        .environment(ViewModel())
}
