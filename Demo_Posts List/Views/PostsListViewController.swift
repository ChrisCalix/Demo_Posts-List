//
//  PostsListViewController.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import UIKit

final class PostsListViewController: UIViewController {
    
    var viewModel: PostsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        viewModel = PostsListViewModel()
        viewModel.fetchAllPosts()
    }
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
    }
}
