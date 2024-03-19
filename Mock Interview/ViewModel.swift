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
}
