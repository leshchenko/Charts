//
//  ChartsControllView.swift
//  ChartsApp
//
//  Created by Ruslan on 3/12/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

protocol ChartsControllViewDelegate {
    func arrowPan(gesture: UIPanGestureRecognizer)
}
class ChartsControllView: UIView {
    
    static let leftArrowTag = 1001
    static let rightArrowTag = 1002
    
    var delegate: ChartsControllViewDelegate?
    
    private var leftArrowView: UIView?
    private var rightArrowView: UIView?
    
    private let arrowViewWidth: CGFloat = 20
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redrawViews()
    }
    
    fileprivate func setup() {
        leftArrowView = ArrowView.init(frame: .init(x: 0, y: 0, width: arrowViewWidth, height: frame.height), isLeftArrow: true)
        leftArrowView?.tag = ChartsControllView.leftArrowTag
        leftArrowView?.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(arrow(pan:))))
        addSubview(view: leftArrowView)
        
        rightArrowView = ArrowView.init(frame: .init(x: frame.width - arrowViewWidth, y: 0, width: arrowViewWidth, height: frame.height), isLeftArrow: false)
        rightArrowView?.tag = ChartsControllView.rightArrowTag
        rightArrowView?.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(arrow(pan:))))
        addSubview(view: rightArrowView)
        
        backgroundColor = UIColor.clear
        clipsToBounds = true
        layer.borderColor = R.color.chartsControlArrowsColor().cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
    }
    
    fileprivate func redrawViews() {
        leftArrowView?.frame = .init(x: 0, y: 0, width: arrowViewWidth, height: frame.height)
        rightArrowView?.frame = .init(x: frame.width - arrowViewWidth, y: 0, width: arrowViewWidth, height: frame.height)
    }
    
    @objc fileprivate func arrow(pan: UIPanGestureRecognizer) {
        delegate?.arrowPan(gesture: pan)
    }

}
