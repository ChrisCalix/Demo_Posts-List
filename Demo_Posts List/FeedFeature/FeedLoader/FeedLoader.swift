//
//  FeedLoader.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation

protocol FeedLoader {
    typealias FeedResult = Swift.Result<[FeedPost], Swift.Error>
    
    func load(completion: @escaping (FeedResult) -> Void)
}
