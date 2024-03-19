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
    
    func nextStep() {
        if state == .question1 {
            state = .question2
        } else if state == .question2 {
            state = .question3
        } else if state == .question3 {
            state = .feedback
        }
    }
    
    /// Save 3 responses
    func saveQuestions(questions: [String]) {
        UserDefaults.standard.setValue(questions[0], forKey: "question-1")
        UserDefaults.standard.setValue(questions[1], forKey: "question-2")
        UserDefaults.standard.setValue(questions[2], forKey: "question-3")
    }
    
    // Get 3 saved quesitons from user defaults.
    func readQuestions() -> [String] {
        guard let question1 = UserDefaults.value(forKey: "question-1") as? String else {
            return []
        }
        guard let question2 = UserDefaults.value(forKey: "question-2") as? String else {
            return []
        }
        guard let question3 = UserDefaults.value(forKey: "question-3") as? String else {
            return []
        }
        return [question1, question2, question3]
    }
}
