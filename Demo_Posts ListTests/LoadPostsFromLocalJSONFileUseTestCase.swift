//
//  LoadPostsFromLocalJSONFileUseTestCase.swift
//  Demo_Posts ListTests
//
//  Created by Sonic on 26/5/23.
//

import XCTest
@testable import Demo_Posts_List

final class LoadPostsFromLocalJSONFileUseTestCase: XCTestCase {
    
    func test_load_doesNotFoundFileNameError() {
        let (sut, _) = makeSUT(fileName: "DoesNotExistFile")
        
        expect(sut, toCompleteWith: .failure(.notFound))
    }
    
    func test_load_deliversInvalidDataFromFileNameWithInvalidJSON() {
        let (sut, _) = makeSUT(fileName: "InvalidJSON")
        expect(sut, toCompleteWith: .failure(.invalidData))
    }
    
    func test_load_deliversSuccessWithNoItemsFileNameWithEmptyJSONList() {
        let (sut, _) = makeSUT(fileName: "EmptyPosts")
        expect(sut, toCompleteWith: .success([]))
    }
    
    func test_load_deliversSuccessWithItemsFromFileNameWithJSONItems() {
        let (sut, _) = makeSUT()
        
        let item1 = makePosts(name: "nameTest", description: "Description")
        let item2 = makePosts(name: "namingTest", description: "Description Advanced")
        
        expect(sut, toCompleteWith: .success([item1.model, item2.model]))
    }
    
//    MARK: Helpers
    func makeSUT(fileName: String = "PostsList",
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalFeedLoader, reader: FileReader){
        let reader = JSONFileReader(bundle: Bundle(for: type(of: self)))
        let sut = LocalFeedLoader(fileName: fileName, reader: reader)
        return (sut, reader)
    }
    
    func expect(_ sut: LocalFeedLoader,
                          toCompleteWith expectedResult: Result<[FeedPost], LocalFeedLoader.Error>,
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
        
        waitForExpectations(timeout: 0.1)
    }
    
    func makePosts(name: String, description: String) -> (model: FeedPost, json: [String: Any]) {
            let item = FeedPost(name: name,
                                description: description)
            
            let json = [
                "name": item.name,
                "description": item.description
            ].compactMapValues { $0 }
            
            return (item, json)
        }

}
