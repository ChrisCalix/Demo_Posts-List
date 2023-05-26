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
    
    func test_load_doesNotFoundFileNameError() {
        let reader = FileReaderSpy()
        let sut = LocalFeedLoader(fileName: "PostsList.json", reader: reader)
        let readerError = LocalFeedLoader.Error.notFound
        
        let exp = expectation(description: "wait for load completion")
        
        sut.load { result in
            defer { exp.fulfill() }
            
            switch result {
            case let .failure(receivedError as LocalFeedLoader.Error):
                XCTAssertEqual(receivedError, readerError)
            default:
                XCTFail("Error in completion method")
            }
        }
        reader.complete(with: readerError)
        
        waitForExpectations(timeout: 0.1)
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
    
    func complete(with error: Error, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
        guard messages.indices.contains(index) else {
            return XCTFail("Can't complete request never made")
        }
        messages[index].completion(.failure(error))
    }
}
