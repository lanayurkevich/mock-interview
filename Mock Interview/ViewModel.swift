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
    var questions = ["", "", ""]
    var printedQuestion: String = ""
    var answers: [String] = ["", "", ""]
    var title: String = "Question 1"
    func nextStep(userResponse: String) {
        if state == .question1 {
            state = .question2
            printedQuestion = questions[1]
            answers[0] = userResponse
            title = "Question 2"
        } else if state == .question2 {
            state = .question3
            printedQuestion = questions[2]
            answers[1] = userResponse
            title = "Question 3"
        } else if state == .question3 {
            answers[2] = userResponse
            state = .validationAndFeedback
            title = "Check your answers"
        }
    }
    //start over after checking answers
    func reset() {
        state = .question1
        title = "Question 1"
        printedQuestion = questions[0]
    }
}
