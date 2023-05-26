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
        let (_, reader) = makeSUT()
        
        XCTAssertTrue(reader.requestedFiles.isEmpty)
    }
    
    func test_load_twiceRequestDataFromFileTwice() {
        let fileName = "PostsList.json"
        let (sut, reader) = makeSUT(fileName: fileName)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(reader.requestedFiles, [fileName, fileName])
    }
    
    func test_load_doesNotFoundFileNameError() {
        let (sut, reader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.notFound)) {
            let readerError = LocalFeedLoader.Error.notFound
            reader.complete(with: readerError)
        }
    }
    
    func test_load_deliversInvalidDataFromFileNameWithInvalidJSON() {
        let (sut, reader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data("Invalid JSON".utf8)
            reader.complete(with: invalidJSON)
        }
    }
    
    func test_load_deliversSuccessWithNoItemsFromFileNameWithEmptyJSONList() {
        let (sut, reader) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let json = makePostsListJSON([])
            reader.complete(with: json)
        }
    }
    
    func test_load_deliversSuccessWithItemsFromFileNameWithNoEmptyJSONItems() {
        let (sut, reader) = makeSUT()
        
        let item1 = makePost()
        let item2 = makePost()
        let item3 = makePost()
        
        expect(sut, toCompleteWith: .success([item1.model, item2.model, item3.model])) {
            let json = makePostsListJSON([item1.json, item2.json, item3.json])
            reader.complete(with: json)
        }
    }
}
