//
//  ViewModel.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 19/03/2024.
//

import Foundation

enum InterviewState {
    case initial
    case question1
    case question2
    case question3
    case validationAndFeedback
}

@Observable
class ViewModel {
    var state: InterviewState = .initial
    var questions: [String] = Array(repeating: "", count: 3)
    var question: String = ""
    var answers: [String] = Array(repeating: "", count: 3)
    var title: String = "Question 1"
    func nextStep(_ response: String) {
        if state == .question1 {
            state = .question2
            question = questions[1]
            answers[0] = response
            title = "Question 2"
        } else if state == .question2 {
            state = .question3
            question = questions[2]
            answers[1] = response
            title = "Question 3"
        } else if state == .question3 {
            answers[2] = response
            state = .validationAndFeedback
            title = "Check your answers"
        }
    }
    
    func reset() {
        state = .question1
        title = "Question 1"
        question = questions[0]
    }
}
