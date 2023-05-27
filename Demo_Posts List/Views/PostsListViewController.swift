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
    
    private func setupBinding() {
        viewModel.output.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.output.title
            .drive(navigationItem.rx.title)
            .disposed(by: bag)
    }
    
    @objc func addNewPost() {
        
    }
}
