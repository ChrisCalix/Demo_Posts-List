//
//  PostsListViewController.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class PostsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil ), forCellReuseIdentifier: PostTableViewCell.identifier)
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<PostsItemSection> { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.setup(using: item)
        return cell
    }
    
    private var viewModel: PostsListViewPresentable!
    private var bag = DisposeBag()
    var viewModelBuilder: PostsListViewPresentable.viewModelBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
        setupBinding()
        fetchAllPosts()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.setRightBarButton(makeAddBarButton(), animated: true)
    }
    
    private func configureViewModel() {
        viewModel = viewModelBuilder((
            textFilter: searchTextField.rx.text.orEmpty.asDriver(), ()
        ))
    }
    
    private func fetchAllPosts() {
        viewModel.fetchAllPosts()
    }
    
    private func setupBinding() {
        viewModel.output.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.output.title
            .drive(navigationItem.rx.title)
            .disposed(by: bag)
    }
}

extension PostsListViewController {
    
    func makeAddBarButton() -> UIBarButtonItem {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPost))
        addBarButton.tintColor = UIColor.label
        return addBarButton
    }
    
    @objc private func addNewPost() {
        let (alertController, alertAction) = makeCustomAlert()
        alertController.addAction(alertAction)
        
        present(alertController, animated: true)
    }
    
    private func makeCustomAlert() -> (alertController: UIAlertController, alertAction: UIAlertAction) {
        
        var nameTextField = UITextField()
        var descriptionTextField = UITextField()
        
        let alert = UIAlertController(title: "Create New Post", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Create", style: .default) { [weak self] actions in
            guard let self, let namePost = nameTextField.text, let desctiptionPost = descriptionTextField.text,!desctiptionPost.isEmpty, !namePost.isEmpty else { return }

            let newPost = PostModel(id: tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0) ?? 0, name: namePost, description: desctiptionPost)
            self.viewModel.addNewPost(using: newPost)
        }
        
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "New Post"
            nameTextField = alertTextField
        }
        
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Description"
            descriptionTextField = alertTextField
        }
        
        return (alert, action)
    }
}
