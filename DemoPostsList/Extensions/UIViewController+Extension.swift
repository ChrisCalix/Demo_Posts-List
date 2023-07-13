//
//  UIViewController+Extension.swift
//  Demo_Posts List
//
//  Created by Sonic on 26/5/23.
//

import UIKit

extension UIViewController {
    
    public static func instantiate(from storyboardName: String) -> Self? {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: className) as? Self
    }
}
