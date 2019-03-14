//
//  ChartsView.swift
//  ChartsApp
//
//  Created by Ruslan on 3/11/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

protocol ChartsNavigationViewDelegate {
    func selectedValues(indexes: [Int])
}

class ChartsNavigationView: UIView {

    var leftConstraint: NSLayoutConstraint?
    var rightConstraint: NSLayoutConstraint?
    
    var initialLeftConstraintValue: CGFloat = 0
    var initialRightConstraintValue: CGFloat = 0
    
    var delegate: ChartsNavigationViewDelegate?
    
    private var xData: [Int] = []
    private var chartsYData: [String: [Int]] = [:]
    private var yHeightPointStep: CGFloat = 0.0
    private var xWidthPointStep: CGFloat = 0.0
    private var chartData: ChartsResponseModelElement?
    
    private var chartsControllView: ChartsControllView?
    private let minChartsControllWidth: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func update(chartData: ChartsResponseModelElement?) {
        self.chartData = chartData
        if let chartData = chartData {
            chartData.columns.forEach { (column) in
                if let nameElement = column.first, case let .string(name) = nameElement {
                    
                    if chartData.types[name] == ChartTypes.x.rawValue {
                        column.forEach({ (xPoint) in
                            if case let .integer(point) = xPoint {
                                xData.append(point)
                            }
                        })
                    } else {
                        var yData:[Int] = []
                        column.forEach({ (yPoint) in
                            if case let .integer(point) = yPoint {
                                yData.append(point)
                            }
                            
                        })
                        chartsYData[name] = yData
                    }
                    
                }
            }
            var maxElements:[Int] = []
            chartsYData.forEach({ maxElements.append($0.value.max() ?? 0) })
            
            yHeightPointStep = frame.height / CGFloat(integerLiteral: maxElements.max() ?? 0)
            xWidthPointStep = frame.width/CGFloat(integerLiteral: xData.count)
        }
    }
    
    fileprivate func setup() {
       addChartsControllView()
    }
    
    private func addChartsControllView() {
        chartsControllView = ChartsControllView()
        if let controllView = chartsControllView {
            controllView.delegate = self
            controllView.translatesAutoresizingMaskIntoConstraints = false
            controllView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(chartsControllPan(gesture:))))
            addSubview(controllView)
            
            
            leftConstraint = NSLayoutConstraint(item: controllView,
                                                attribute: .leading,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .leading,
                                                multiplier: 1,
                                                constant: frame.width - (frame.width * 0.5))
            initialLeftConstraintValue = leftConstraint?.constant ?? 0
            
            rightConstraint = NSLayoutConstraint.init(item: controllView,
                                                      attribute: .trailing,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: .trailing,
                                                      multiplier: 1,
                                                      constant: 0)
            initialRightConstraintValue = rightConstraint?.constant ?? 0
            
            
            
            let bottomConstraint = NSLayoutConstraint(
                item: controllView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottom,
                multiplier: 1,
                constant:2)
            
            let topConstraint = NSLayoutConstraint(
                item: controllView,
                attribute: .top,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant:-2)
            self.addConstraints([leftConstraint!, rightConstraint!, topConstraint, bottomConstraint])
            controllView.setNeedsLayout()
            addHalfTransparentViews()
        }
    }
    
    private func addHalfTransparentViews() {
        let color = UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.3)
        let leftTransparentView = UIView()
        leftTransparentView.translatesAutoresizingMaskIntoConstraints = false
        leftTransparentView.backgroundColor = color
        addSubview(leftTransparentView)
        let leftViewLeftConstraint = NSLayoutConstraint(item: leftTransparentView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .leading,
                                            multiplier: 1,
                                            constant: 0)
        
        let leftViewRightConstraint = NSLayoutConstraint.init(item: leftTransparentView,
                                                  attribute: .trailing,
                                                  relatedBy: .equal,
                                                  toItem: chartsControllView!,
                                                  attribute: .leading,
                                                  multiplier: 1,
                                                  constant: 0)

        let leftViewBottomConstraint = NSLayoutConstraint(
            item: leftTransparentView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant:0)
        
        let leftViewTopConstraint = NSLayoutConstraint(
            item: leftTransparentView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant:0)
        self.addConstraints([leftViewLeftConstraint, leftViewRightConstraint, leftViewBottomConstraint, leftViewTopConstraint])
        
        let rightTransparentView = UIView()
        rightTransparentView.translatesAutoresizingMaskIntoConstraints = false
        rightTransparentView.backgroundColor = color
        addSubview(rightTransparentView)
        let rightViewLeftConstraint = NSLayoutConstraint(item: rightTransparentView,
                                                attribute: .leading,
                                                relatedBy: .equal,
                                                toItem: chartsControllView!,
                                                attribute: .trailing,
                                                multiplier: 1,
                                                constant: 0)
        
        let rightViewRightConstraint = NSLayoutConstraint.init(item: rightTransparentView,
                                                      attribute: .trailing,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: .trailing,
                                                      multiplier: 1,
                                                      constant: 0)
        
        let rightViewBottomConstraint = NSLayoutConstraint(
            item: rightTransparentView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant:0)
        
        let rightViewTopConstraint = NSLayoutConstraint(
            item: rightTransparentView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant:0)
        self.addConstraints([rightViewLeftConstraint, rightViewRightConstraint, rightViewBottomConstraint, rightViewTopConstraint])
    }
    
    override func draw(_ rect: CGRect) {
        drawChartsNavigation(in: rect)
    }
    
    private func drawChartsNavigation(in rect: CGRect) {
        if let chartData = chartData {
            chartsYData.forEach { (yData) in
                let path = UIBezierPath()
                path.lineWidth = 1.0
                xData.enumerated().forEach { (offset: Int, element: Int) in
                    let xPos = CGFloat(offset) * xWidthPointStep
                    let yPos = rect.maxY - (CGFloat(yData.value[offset]) * yHeightPointStep)
                    if offset == 0 {
                        path.move(to: .init(x: xPos, y: yPos))
                    } else {
                        path.addLine(to: .init(x: xPos, y: yPos))
                    }
                }
                UIColor.init(hexFromString: chartData.colors[yData.key] ?? "").setStroke()
                path.stroke()
            }
        }
        detectSelectedChartRange()
    }
    
    private func detectSelectedChartRange() {
        let controllFrame = chartsControllView?.frame ?? .zero
        var selectedColumnsIndexes: [Int] = []
        for index in 0...(chartData?.columns.first?.count ?? 0) {
            let xPos = CGFloat(index) * xWidthPointStep
            if (controllFrame.minX...controllFrame.maxX).contains(xPos) {
                selectedColumnsIndexes.append(index)
            }
        }
        delegate?.selectedValues(indexes: selectedColumnsIndexes)
    }
    
    @objc private func chartsControllPan(gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: self)
        if gesture.state == .changed {
            if initialLeftConstraintValue + point.x <= 0 {
                leftConstraint?.constant = 0
                initialLeftConstraintValue = 0
                initialRightConstraintValue = rightConstraint?.constant ?? 0
            } else if initialRightConstraintValue + point.x >= 0 {
                rightConstraint?.constant = 0
                initialRightConstraintValue = 0
                initialLeftConstraintValue = leftConstraint?.constant ?? 0
            } else {
                leftConstraint?.constant = initialLeftConstraintValue + point.x
                rightConstraint?.constant = initialRightConstraintValue + point.x
            }
            detectSelectedChartRange()
        } else if gesture.state == .ended {
            initialLeftConstraintValue = leftConstraint?.constant ?? 0
            initialRightConstraintValue = rightConstraint?.constant ?? 0
        } else if gesture.state == .cancelled {
            gesture.isEnabled = true
        }
    }
}

// MARK: - ChartsControllViewDelegate
extension ChartsNavigationView: ChartsControllViewDelegate {
    func arrowPan(gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: self)
        let isLeftSwipe = gesture.velocity(in: self).x < 0
        if gesture.state == .changed {
            if gesture.view?.tag == ChartsControllView.leftArrowTag {
                if initialLeftConstraintValue + point.x <= 0 {
                    leftConstraint?.constant = 0
                    initialLeftConstraintValue = 0
                    gesture.isEnabled = false
                } else {
                    if chartsControllView?.frame.width ?? 0 <= minChartsControllWidth && !isLeftSwipe {
                        gesture.isEnabled = false
                        initialLeftConstraintValue = leftConstraint?.constant ?? 0
                        return
                    }
                    leftConstraint?.constant = initialLeftConstraintValue + point.x
                }
            } else if gesture.view?.tag == ChartsControllView.rightArrowTag {
                if initialRightConstraintValue + point.x >= 0 {
                    rightConstraint?.constant = 0
                    initialRightConstraintValue = 0
                    gesture.isEnabled = false
                } else {
                    if chartsControllView?.frame.width ?? 0 <= minChartsControllWidth && isLeftSwipe {
                        gesture.isEnabled = false
                        initialRightConstraintValue = rightConstraint?.constant ?? 0
                        return
                    }
                     rightConstraint?.constant = initialRightConstraintValue + point.x
                }
            }
            detectSelectedChartRange()
        } else if gesture.state == .ended {
            initialLeftConstraintValue = leftConstraint?.constant ?? 0
            initialRightConstraintValue = rightConstraint?.constant ?? 0
        } else if gesture.state == .cancelled {
            gesture.isEnabled = true
        }
    }
}
