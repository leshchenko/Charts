//
//  ChartsView.swift
//  ChartsApp
//
//  Created by Ruslan on 3/11/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

class ChartsNavigationView: UIView {
    
    var selectedChartPosition: Int = 3
    var centerX: NSLayoutConstraint?
    var initialCenterValue: CGFloat = 0
    
    var chartsData: ChartsResponseModel?
    
    override func draw(_ rect: CGRect) {
        drawChartsNavigation(in: rect)
    }
    
    
    private func drawChartsNavigation(in rect: CGRect) {
        if let chartData = chartsData?[selectedChartPosition] {
            let width = rect.width
            let height = rect.height
            var xData:[Int] = []
            var chartsYData:[String:[Int]] = [:]
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
            
            let yHeightPointStep = height / CGFloat(integerLiteral: maxElements.max() ?? 0)
            let xWidthPointStep = width/CGFloat(integerLiteral: xData.count)
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
        
        
        let controlView = ChartsControllView.init(frame: CGRect.init(x: rect.minX, y:rect.minY, width: rect.width * 0.3, height: rect.height))
//        controlView.backgroundColor = UIColor.white
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(chartsControllPan(gesture:))))
        addSubview(controlView)
        
        centerX = NSLayoutConstraint(
            item: controlView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1,
            constant:0)
        initialCenterValue = centerX?.constant ?? 0
        
        let widthConstraint = NSLayoutConstraint(
            item: controlView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant:rect.width * 0.3)
        
        let bottomConstraint = NSLayoutConstraint(
            item: controlView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant:0)
        
        let topConstraint = NSLayoutConstraint(
            item: controlView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant:0)
        self.addConstraints([centerX!, widthConstraint, topConstraint, bottomConstraint])
    }
    
    @objc private func chartsControllPan(gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: self)
    
        if gesture.state == .changed {
            centerX?.constant = initialCenterValue + point.x
        } else if gesture.state == .ended {
            initialCenterValue = centerX?.constant ?? 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
