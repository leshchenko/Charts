//
//  ArrowView.swift
//  ChartsApp
//
//  Created by Ruslan on 3/12/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

class ArrowView: UIView {
    
    var leftArrow: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(frame: CGRect, isLeftArrow: Bool) {
        super.init(frame: frame)
        leftArrow = isLeftArrow
        setup()
    }
    
    private func setup() {
        backgroundColor = R.color.chartsControlArrowsColor()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 4
        path.lineCapStyle = .round
        let centerY = rect.height/2
        let centerX = rect.width * (leftArrow ? 0.3 : 0.6)
        path.move(to: .init(x: centerX, y: centerY))
        path.addLine(to: .init(x: rect.width * (leftArrow ? 0.8 : 0.2), y: rect.height * 0.3))
        path.move(to: .init(x: centerX, y: centerY))
        path.addLine(to: .init(x: rect.width * (leftArrow ? 0.8 : 0.2), y: rect.height * 0.7))
        UIColor.white.setStroke()
        path.stroke()
    }
}
