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
    
    //MARK: Helpers
    
    private func makeSUT(fileName: String = "PostsList.json",
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalFeedLoader, reader: FileReaderSpy){
        let reader = FileReaderSpy()
        let sut = LocalFeedLoader(fileName: fileName, reader: reader)
        return (sut, reader)
    }
    
    private func makePostsListJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
    
    private func makePost() -> (model: FeedPost, json: [String: Any]) {
        let item = FeedPost(name: "name", description: "description")
        
        let json = [
            "name": item.name,
            "description": item.description
        ].compactMapValues{ $0 }
        
        return (item, json)
    }
    
    private func expect(_ sut: LocalFeedLoader,
                          toCompleteWith expectedResult: Result<[FeedPost], LocalFeedLoader.Error>,
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
    
    func complete(with data: Data, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
        guard messages.indices.contains(index) else {
            return XCTFail("Can't complete request naver made")
        }
        messages[index].completion(.success(data))
    }
}
