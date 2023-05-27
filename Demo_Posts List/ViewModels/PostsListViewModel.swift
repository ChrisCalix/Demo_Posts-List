//
//  PostsListViewModel.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation
import RxCocoa

protocol PostsListViewPresentable {
    typealias Input = (
        textFilter: Driver<String>, ()
    )
    typealias Output = (
        title: Driver<String>,
        sections: Driver<[PostModel]>
    )
    typealias Dependencies = (
        title: String, ()
    )
    typealias viewModelBuilder = (PostsListViewPresentable.Input) -> PostsListViewPresentable
    
    var input: Self.Input { get }
    var ouput: Self.Output { get }
    
    func fetchAllPosts()
}

struct PostsListViewModel: PostsListViewPresentable {
    typealias State = (posts: BehaviorRelay<[PostModel]>, ())
    
    let input: PostsListViewPresentable.Input
    let ouput: PostsListViewPresentable.Output
    private let state: State = ( posts: BehaviorRelay<[PostModel]>(value: []), ())
    
    init(input: PostsListViewPresentable.Input,
         dependencies: PostsListViewPresentable.Dependencies) {
        self.input = input
        self.ouput = PostsListViewModel.ouput(input: input, dependencies: dependencies, state: state)
    }
    
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

private extension PostsListViewModel {
    
    static func ouput(input: PostsListViewPresentable.Input,
                      dependencies: PostsListViewPresentable.Dependencies,
                      state: State) -> PostsListViewPresentable.Output {
        
        
        return (
            title: Driver.just(dependencies.title),
            sections: Driver.just(state.posts.value)
        )
    }
}
