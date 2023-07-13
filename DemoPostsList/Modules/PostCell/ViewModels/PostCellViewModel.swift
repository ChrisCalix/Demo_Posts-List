//
//  PostCellViewModel.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import RxDataSources
import PostsList

public struct PostCellViewModel: IdentifiableType, Equatable {
    public typealias Identity = String
    
    public var identity: String
    let title: String
    let desctiption: String
    
    init(from post: PostModel) {
        self.title = post.name
        self.desctiption = post.description
        self.identity = title + desctiption
    }
}
