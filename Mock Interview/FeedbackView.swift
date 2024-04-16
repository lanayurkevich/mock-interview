//
//  FeedbackView.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 16/04/2024.
//

import SwiftUI

struct FeedbackView: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel
    var body: some View {
        ScrollView{
            Text("Answer 1")
            Text(viewModel.answers[0])
            Text("Answer 2")
            Text(viewModel.answers[1])
            Text("Answer 3")
            Text(viewModel.answers[2])
            Button("Start Again") {
                viewModel.reset()
            }
            Button("Submit") {
                // request to network model
            }
        }
    }
}

#Preview {
    FeedbackView()
}
