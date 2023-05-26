//
//  LoadPostsFromLocalUseTestCase.swift
//  Demo_Posts ListTests
//
//  Created by Sonic on 26/5/23.
//

import XCTest
@testable import Demo_Posts_List

final class LoadPostsFromLocalUseTestCase: XCTestCase {
    
    func test_init_doesNotDataFromLocalJson() {
        let reader = FileReaderSpy()
        let _ = LocalFeedLoader(fileName: "PostsList.json", reader: reader)
        
        XCTAssertTrue(reader.requestedFiles.isEmpty)
    }
}

private final class FileReaderSpy: FileReader {
    
    private var messages = [
        (fileName: String, completion: (FileReader.Result) -> Void)
    ]()
    var requestedFiles: [String] {
        return messages.map(\.fileName)
    }
    
    func get(from fileName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
    }
}
