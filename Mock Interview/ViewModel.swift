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
    case feedback
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
            state = .feedback
        }
    }
    
    func reset() {
        state = .question1
        title = "Question 1"
        question = questions[0]
    }
    
    /// Save 3 responses
    func saveAnswers(answers: [String]) {
        UserDefaults.standard.setValue(answers[0], forKey: "answer-1")
        UserDefaults.standard.setValue(answers[1], forKey: "answer-2")
        UserDefaults.standard.setValue(answers[2], forKey: "answer-3")
    }
    
    // Get 3 saved quesitons from user defaults.
    func readAnswer() -> [String] {
        guard let answer1 = UserDefaults.value(forKey: "answer-1") as? String else {
            return []
        }
        guard let answer2 = UserDefaults.value(forKey: "answer-2") as? String else {
            return []
        }
        guard let answer3 = UserDefaults.value(forKey: "answer-3") as? String else {
            return []
        }
        return [answer1, answer2, answer3]
    }
}
