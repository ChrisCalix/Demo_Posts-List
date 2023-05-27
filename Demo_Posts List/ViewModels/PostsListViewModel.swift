//
//  PostsListViewModel.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation

struct PostsListViewModel {
    
    func fetchAllPosts() {
        let reader = JSONFileReader()
        let localFeedLoader = LocalFeedLoader(fileName: Constants.JSONFile.postsList.rawValue,
                                              reader: reader)
        localFeedLoader.load { result in
            switch result {
            case let .success(receivedPosts):
//            TODO: implement how use the received data from JSON File
                print(receivedPosts)
            case .failure(_):
                break
            }
        }
    }
}
