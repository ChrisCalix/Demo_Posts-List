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
        
        tableView
            .rx
            .itemDeleted
            .subscribe(onNext: { indexPath in
                self.viewModel.removePost(at: indexPath)
            })
            .disposed(by: bag)
    }
}

//MARK: Add Button create and Actions
extension PostsListViewController {
    
    private func makeAddBarButton() -> UIBarButtonItem {
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
            guard let self else { return }
            
            guard let namePost = self.validateAndReturnTextFieldValue(textField: nameTextField, messageForEmptyText: "We can't add this post, because you don't add any name") else { return }
            
            guard let descriptionPost = self.validateAndReturnTextFieldValue(textField: descriptionTextField, messageForEmptyText: "We can't add this post, because you don't add any name or description") else { return}

            let newPost = PostModel(name: namePost, description: descriptionPost)
            viewModel.addNewPost(using: newPost){ [weak self] isAdded in
                guard let self else { return }
                if !isAdded {
                    presentAlertAdvice(with: "We can't add this post, because already exist other with the same name and description")
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
    
    func makeCustomAlertAdvice(title: String = "Operation Failed", message: String) -> UIAlertController {
        let alertAdvice = UIAlertController(title: "Operation Failed", message: "We can't add this post, because already exist other with the same name and description", preferredStyle: .alert)
        alertAdvice.addAction(UIAlertAction(title: "Agree", style: .destructive))
        return alertAdvice
    }
    
    func validateAndReturnTextFieldValue(textField: UITextField, messageForEmptyText: String) -> String? {
        guard let namePost = textField.text,
              !namePost.isEmpty
        else {
            presentAlertAdvice(with: messageForEmptyText)
            return nil
        }
        return namePost
    }
    
    func presentAlertAdvice(with message: String) {
        let alertAdvice = self.makeCustomAlertAdvice(message: message)
        
        self.present(alertAdvice, animated: true)
    }
}