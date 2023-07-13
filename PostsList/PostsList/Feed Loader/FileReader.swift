//
//  FileReader.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation

protocol FileReader {
    typealias Result = Swift.Result<Data, Error>
    
    func get(from fileName: String, completion: @escaping(FileReader.Result) -> Void)
}
