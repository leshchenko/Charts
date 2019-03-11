//
//  ChartsView.swift
//  ChartsApp
//
//  Created by Ruslan on 3/11/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

class ChartsView: UIView {
    
    var selectedChartPosition: Int = 3
    
    var chartsData: ChartsResponseModel?
    
    override func draw(_ rect: CGRect) {
        let rectForChartsNavigation = CGRect.init(x: 0, y: rect.height, width: rect.width, height: rect.height * 0.1)
        drawChartsNavigation(in: rectForChartsNavigation)
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
                    let yPos = rect.minY - (CGFloat(yData.value[offset]) * yHeightPointStep)
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
}
