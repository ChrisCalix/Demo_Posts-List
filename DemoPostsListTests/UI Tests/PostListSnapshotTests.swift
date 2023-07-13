//
//  PostListSnapshotTests.swift
//  DemoPostsListTests
//
//  Created by Sonic on 13/7/23.
//

import XCTest
import DemoPostsList

class PostListSnapshotTests: XCTestCase {
    
    func test_PostList() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .light)), named: "POST_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .dark)), named: "POST_LIST_dark")
    }
    // MARK: - Helpers
    
    private func makeSUT() -> PostsListViewController {
        let controller = PostsListViewController.instantiate(from: Constants.Views.home.rawValue)!
        controller.viewModelBuilder = {
            return PostsListViewModel(input: $0, dependencies: (title: "Post List", ()))
        }
        controller.loadViewIfNeeded()
        return controller
    }
    
    func assert(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting.", file: file, line: line)
            return
        }
        
        if snapshotData != storedSnapshotData {
            let temporarySnapShotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(snapshotURL.lastPathComponent)
            
            try? snapshotData?.write(to: temporarySnapShotURL)
            
            XCTFail("New snapshot does not match stored snapshot URL: \(temporarySnapShotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }
    
    func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
 
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        do {
            try FileManager.default.createDirectory(at: snapshotURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            try snapshotData?.write(to: snapshotURL)
            XCTFail("Record succeeded - use `assert` to compare the snapshot from now on.", file: file, line: line)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }
    
    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        return URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }
    
    private func makeSnapshotData(for snapshot: UIImage, file: StaticString = #file, line: UInt = #line) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }
        
        return data
    }
}
