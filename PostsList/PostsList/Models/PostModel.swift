//
//  PostModel.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation

public struct PostModel: Decodable, Equatable {
    let name: String
    let description: String
}
