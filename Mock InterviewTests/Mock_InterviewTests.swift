//
//  Mock_InterviewTests.swift
//  Mock InterviewTests
//
//  Created by Svetlana Yurkevich on 18/03/2024.
//

import XCTest
@testable import Mock_Interview

final class Mock_InterviewTests: XCTestCase {
    
    var subject = ViewModel() // subject of what we aim to test

    func testViewModelStateChanges() {
        let answer1 = "User response to answer 1"
        let answer2 = "User response to answer 2"
        let answer3 = "User response to answer 3"

        // Change state to question 1.
        subject.state = .question1
        XCTAssertEqual(subject.state, .question1)

        subject.nextStep(userResponse: answer1)
        XCTAssertEqual(subject.state, .question2)

        subject.nextStep(userResponse: answer2)
        XCTAssertEqual(subject.state, .question3)

        subject.nextStep(userResponse: answer3)
        XCTAssertEqual(subject.state, .validationAndFeedback)

        XCTAssertEqual(subject.answers, [answer1, answer2, answer3])
    }

}
