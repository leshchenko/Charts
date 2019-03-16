//
//  ChartsView.swift
//  ChartsApp
//
//  Created by Ruslan on 3/14/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

class ChartsView: UIView {
    
    private var chartData: ChartsResponseModelElement?
    private var selectedIndexes: [Int] = []
    private var xData: [Int] = []
    private var chartsYData: [String: [Int]] = [:]
    private var yHeightPointStep: CGFloat = 0.0
    private var xWidthPointStep: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        if let chartData = chartData {
            chartsYData.forEach { (yData) in
                let path = UIBezierPath()
                path.lineWidth = 2.0
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
    }
    
    func update(chartData: ChartsResponseModelElement?) {
        self.chartData = chartData
        xData = []
        chartsYData = [:]
        if let chartData = self.chartData, !selectedIndexes.isEmpty {
            chartData.columns.forEach { (column) in
                if let nameElement = column.first, case let .string(name) = nameElement {
                    
                    if chartData.types[name] == ChartTypes.x.rawValue {
                        selectedIndexes.forEach{index in
                            let xItem = column[index]
                            if case let .integer(point) = xItem {
                                xData.append(point)
                            }
                        }
                    } else {
                        var yData:[Int] = []
                        
                        selectedIndexes.forEach { index in
                            let yItem = column[index]
                            if case let .integer(point) = yItem {
                                yData.append(point)
                            }
                        }
                        chartsYData[name] = yData
                    }
                    
                }
            }
            var maxElements:[Int] = []
            chartsYData.forEach({ maxElements.append($0.value.max() ?? 0) })
            
            yHeightPointStep = frame.height / CGFloat(integerLiteral: maxElements.max() ?? 0)
            xWidthPointStep = frame.width/CGFloat(integerLiteral: xData.count)
        }
        UIView.transition(with: self,
                          duration: 0.5,
                          options: .layoutSubviews,
                          animations: {
                          self.setNeedsDisplay()
        }, completion: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
    }
}

extension ChartsView: ChartsNavigationViewDelegate {
    func selectedValues(indexes: [Int]) {
        selectedIndexes = indexes
        update(chartData: chartData)
    }
}
