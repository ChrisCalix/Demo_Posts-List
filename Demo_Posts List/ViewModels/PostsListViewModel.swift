//
//  PostsListViewModel.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

typealias PostsItemSection = AnimatableSectionModel<Int, PostCellViewModel>

protocol PostsListViewPresentable {
    typealias Input = (
        textFilter: Driver<String>, ()
    )
    typealias Output = (
        title: Driver<String>,
        sections: Driver<[PostsItemSection]>
    )
    typealias Dependencies = (
        title: String, ()
    )
    typealias viewModelBuilder = (PostsListViewPresentable.Input) -> PostsListViewPresentable
    
    var input: Self.Input { get }
    var output: Self.Output { get }
    
    func fetchAllPosts()
    func addNewPost(using newPost: PostModel)
}

struct PostsListViewModel: PostsListViewPresentable {
    typealias State = (posts: BehaviorRelay<[PostModel]>, ())
    
    private let state: State = ( posts: BehaviorRelay<[PostModel]>(value: []), ())
    private let lock = NSRecursiveLock()
    let input: PostsListViewPresentable.Input
    let output: PostsListViewPresentable.Output
    
    init(input: PostsListViewPresentable.Input,
         dependencies: PostsListViewPresentable.Dependencies) {
        self.input = input
        self.output = PostsListViewModel.output(input: input, dependencies: dependencies, state: state)
    }
    
    func fetchAllPosts() {
        let reader = JSONFileReader()
        let localFeedLoader = LocalFeedLoader(fileName: Constants.JSONFile.postsList.rawValue,
                                              reader: reader)
        localFeedLoader.load { result in
            switch result {
            case let .success(receivedPosts):
                self.addNewPosts(from: receivedPosts)
            case .failure(_):
                break
            }
        }
    }
    
    private func addNewPosts(from posts: [PostModel]) {
        posts.forEach { post in
            self.addNewPost(using: post)
        }
    }
    
    func addNewPost(using newPost: PostModel) {
        lock.lock();
        defer { lock.unlock() }
        var posts = state.posts.value
        posts.append(newPost)
        state.posts.accept(posts)
    }
}

private extension PostsListViewModel {
    
    static func output(input: PostsListViewPresentable.Input,
                      dependencies: PostsListViewPresentable.Dependencies,
                      state: State) -> PostsListViewPresentable.Output {
        
        let textFilterObservable = input.textFilter.asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        let postsObservable = state.posts
            .distinctUntilChanged()
            .skip(1)
            .asObservable()
        
        let sections = Observable
            .combineLatest(textFilterObservable, postsObservable)
            .map({ searchKey, posts in
                return searchKey.isEmpty ? posts : posts.filter({ post -> Bool in
                    post.name.lowercased()
                        .replacingOccurrences(of: " ", with: "")
                        .hasPrefix(searchKey.lowercased())
                })
            })
            .map({ arg in
                arg.compactMap(PostCellViewModel.init)
            })
            .map({ [PostsItemSection(model: 0, items: $0)]})
            .asDriver(onErrorJustReturn: [])
        
        return (
            title: Driver.just(dependencies.title),
            sections: sections
        )
    }
}
