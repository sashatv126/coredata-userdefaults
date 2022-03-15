//
//  Extension.swift
//  M20
//
//  Created by Владимир on 14.03.2022.
//
import UIKit

extension UIViewController {
    func cCB (selector : Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage.init(systemName: "plus"), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        let mButton = UIBarButtonItem(customView: button)
        return mButton
    }
    func cBC (selector : Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setTitle("SORT", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        let mButton = UIBarButtonItem(customView: button)
        return mButton
    }
}
