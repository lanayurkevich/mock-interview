//
//  OpenAIResponse.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 19/03/2024.
//

struct OpenAIResponse: Decodable {
    let choices: [Choice]
    
    struct Choice: Decodable {
        let message: Message
        
        struct Message: Decodable {
            let content: String
        }
    }
}
