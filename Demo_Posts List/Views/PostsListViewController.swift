//
//  PostsListViewController.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import UIKit

final class PostsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var viewModel: PostsListViewPresentable!
    var viewModelBuilder: PostsListViewPresentable.viewModelBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
        fetchAllPosts()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPost))
        addBarButton.tintColor = UIColor.label
        navigationItem.setRightBarButton(addBarButton, animated: true)
    }
    
    private func configureViewModel() {
        viewModel = viewModelBuilder((
            textFilter: searchTextField.rx.text.orEmpty.asDriver(), ()
        ))
    }
    
    private func fetchAllPosts() {
        viewModel.fetchAllPosts()
    }
    
    @objc func addNewPost() {
        
    }
}
