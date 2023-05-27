//
//  LoadPostsFromLocalUseTestCase+Helper.swift
//  Demo_Posts ListTests
//
//  Created by Sonic on 26/5/23.
//

import XCTest
@testable import Demo_Posts_List

extension LoadPostsFromLocalUseTestCase {
    
    func makeSUT(fileName: String = "PostsList.json",
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalFeedLoader, reader: FileReaderSpy){
        let reader = FileReaderSpy()
        let sut = LocalFeedLoader(fileName: fileName, reader: reader)
        return (sut, reader)
    }
    
    func makePostsListJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
    
    func makePost() -> (model: PostModel, json: [String: Any]) {
        let item = PostModel(id: 1, name: "name", description: "description")
        
        let dictionary: [String : Any] = [
                "id": item.id,
                "name": item.name,
                "description": item.description
            ]
        
        let json = dictionary.compactMapValues { $0 }
        return (item, json)
    }
    
    func expect(_ sut: LocalFeedLoader,
                          toCompleteWith expectedResult: Result<[PostModel], LocalFeedLoader.Error>,
                          when action: ()-> Void,
                          file: StaticString = #filePath,
                          line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            defer { exp.fulfill() }
            
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as LocalFeedLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
        }
        
        action()
        
        waitForExpectations(timeout: 0.1)
    }
}
