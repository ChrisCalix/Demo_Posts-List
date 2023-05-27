//
//  PostsListViewController+AddButton+Actions.swift
//  Demo_Posts List
//
//  Created by Sonic on 27/5/23.
//

import UIKit

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
