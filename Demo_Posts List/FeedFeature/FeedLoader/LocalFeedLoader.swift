//
//  LocalFeedLoader.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation

struct LocalFeedLoader: FeedLoader {
    
    private let fileName: String
    private let reader: FileReader
    
    init(fileName: String, reader: FileReader) {
        self.fileName = fileName
        self.reader = reader
    }
    
    func load(completion: @escaping (FeedResult) -> Void) {
        reader.get(from: fileName) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                completion(FeedMapper.validateAndMap(data))
            }
        }
    }
}
