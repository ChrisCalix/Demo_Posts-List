//
//  FeedMapper.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation

enum FeedMapper {
    static func validateAndMap(_ data: Data) -> LocalFeedLoader.FeedResult {
        guard let root = try? JSONDecoder().decode([FeedPost].self, from: data) else {
            return .failure(LocalFeedLoader.Error.invalidData)
        }
        return .success(root)
    }
}
