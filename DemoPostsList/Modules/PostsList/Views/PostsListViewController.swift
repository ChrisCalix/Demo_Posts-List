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

public final class PostsListViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil ), forCellReuseIdentifier: PostTableViewCell.identifier)
        }
    }
    
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<PostsItemSection> { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.setup(using: item)
        return cell
    }
    
    private var viewModel: PostsListViewPresentable!
    private var bag = DisposeBag()
    public var viewModelBuilder: PostsListViewPresentable.viewModelBuilder!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
        setupBinding()
        fetchAllPosts()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.setRightBarButton(makeAddBarButton(), animated: true)
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
          return true
        }
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
        
        viewModel.output.sections.map({ posts -> Bool in
            posts[0].items.count != 0
        })
        .drive(emptyImageView.rx.isHidden)
        .disposed(by: bag)
        
        tableView
            .rx
            .itemDeleted
            .subscribe(onNext: { indexPath in
                self.viewModel.removePost(at: indexPath)
            })
            .disposed(by: bag)
    }
    
    func makeCustomAlert() -> (alertController: UIAlertController, alertAction: UIAlertAction) {
        
        var nameTextField = UITextField()
        var descriptionTextField = UITextField()
        
        let alert = UIAlertController(title: "New Post", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Create", style: .default) { [weak self] actions in
            guard let self else { return }
            
            guard let namePost = self.validateAndReturnTextFieldValue(textField: nameTextField, messageForEmptyText: "We can't add this post, because you don't add any name") else { return }
            
            guard let descriptionPost = self.validateAndReturnTextFieldValue(textField: descriptionTextField, messageForEmptyText: "We can't add this post, because you don't add any name or description") else { return}

            let newPost = PostModel(name: namePost, description: descriptionPost)
            self.viewModel.addNewPost(using: newPost){ [weak self] isAdded in
                guard let self else { return }
                if !isAdded {
                    self.presentAlertAdvice(with: "We can't add this post, because already exist other with the same name and description")
                }
            }
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
