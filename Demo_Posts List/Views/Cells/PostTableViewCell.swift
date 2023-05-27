//
//  PostTableViewCell.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
    }

    func setup(using viewModel: PostCellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.desctiption
    }
}
