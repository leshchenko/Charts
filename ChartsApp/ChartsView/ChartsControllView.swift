//
//  ChartsControllView.swift
//  ChartsApp
//
//  Created by Ruslan on 3/12/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

class ChartsControllView: UIView {

    override func draw(_ rect: CGRect) {
        let leftArrowView = ArrowView.init(frame: .init(x: 0, y: 0, width: rect.width * 0.2, height: rect.height), isLeftArrow: true)
        addSubview(leftArrowView)
        let rightArrowView = ArrowView.init(frame: .init(x: rect.width - rect.width * 0.2, y: 0, width: rect.width * 0.2, height: rect.height), isLeftArrow: false)
        addSubview(rightArrowView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        clipsToBounds = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }

}
