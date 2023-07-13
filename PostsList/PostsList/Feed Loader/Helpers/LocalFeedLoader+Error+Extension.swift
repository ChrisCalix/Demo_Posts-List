//
//  LocalFeedLoader+Error+Extension.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation

extension LocalFeedLoader {
    
    public enum Error: Swift.Error {
        case invalidData
        case notFound
    }
}
