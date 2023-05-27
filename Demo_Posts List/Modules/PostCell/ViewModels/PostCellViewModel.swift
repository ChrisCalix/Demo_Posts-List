//
//  PostCellViewModel.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import RxDataSources

struct PostCellViewModel: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String
    let title: String
    let desctiption: String
    
    init(from post: PostModel) {
        self.title = post.name
        self.desctiption = post.description
        self.identity = title + desctiption
    }
}
