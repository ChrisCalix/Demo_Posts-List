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
    
    func test_load_twiceRequestDataFromFileTwice() {
        let fileName = "PostsList.json"
        let reader = FileReaderSpy()
        let sut = LocalFeedLoader(fileName: fileName, reader: reader)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(reader.requestedFiles, [fileName, fileName])
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
        messages.append((fileName, completion))
    }
}
