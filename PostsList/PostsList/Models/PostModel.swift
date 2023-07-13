//
//  PostModel.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation

public struct PostModel: Decodable, Equatable {
    public let name: String
    public let description: String
    
    public init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
