//
//  FileReaderSpy.swift
//  Demo_Posts ListTests
//
//  Created by Sonic on 26/5/23.
//

import XCTest
@testable import Demo_Posts_List

final class FileReaderSpy: FileReader {
    
    private var messages = [
        (fileName: String, completion: (FileReader.Result) -> Void)
    ]()
    var requestedFiles: [String] {
        return messages.map(\.fileName)
    }
    
    func get(from fileName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        messages.append((fileName, completion))
    }
    
    func complete(with error: Error, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
        guard messages.indices.contains(index) else {
            return XCTFail("Can't complete request never made")
        }
        messages[index].completion(.failure(error))
    }
    
    func complete(with data: Data, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
        guard messages.indices.contains(index) else {
            return XCTFail("Can't complete request naver made")
        }
        messages[index].completion(.success(data))
    }
}
