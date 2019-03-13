//
//  UIKitExtensions+UIView.swift
//  ChartsApp
//
//  Created by Ruslan on 3/13/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

extension UIView {
    func addSubview(view: UIView?) {
        if let view = view {
            addSubview(view)
        }
    }
}
