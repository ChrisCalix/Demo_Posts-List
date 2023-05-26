//
//  JSONFileReader.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation

struct JSONFileReader: FileReader {
    
    let bundle: Bundle
    
    init(bundle: Bundle = Bundle.main) {
        self.bundle = bundle
    }
    
    func get(from fileName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            guard let bundlePath = bundle.path(forResource: fileName, ofType: "json") else {
                completion(.failure(LocalFeedLoader.Error.notFound))
                return
            }
            
            guard let data = try String(contentsOfFile: bundlePath).data(using: .utf8) else {
                completion(.failure(LocalFeedLoader.Error.invalidData))
                return
            }
            
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
    
}
