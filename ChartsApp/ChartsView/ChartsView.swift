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
        if let chartData = chartsData?[selectedChartPosition] {
            let width = rect.width
            let height = rect.height
            var xData:[Int] = []
            var chartsYData:[[Int]] = []
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
                        chartsYData.append(yData)
                    }
                    
                }
            }
            
            var maxElements:[Int] = []
            chartsYData.forEach({ maxElements.append($0.max() ?? 0) })
            
            let yHeightPointStep = height / CGFloat(integerLiteral: maxElements.max() ?? 0)
            let xWidthPointStep = width/CGFloat(integerLiteral: xData.count)
            let path = UIBezierPath()
            path.lineWidth = 1.0
            chartsYData.forEach { (yData) in
                xData.enumerated().forEach { (offset: Int, element: Int) in
                    let xPos = CGFloat(offset) * xWidthPointStep - 20
                    let yPos = height - (CGFloat(yData[offset]) * yHeightPointStep)
                    if offset == 0 {
                        path.move(to: .init(x: xPos, y: yPos))
                    } else {
                        path.addLine(to: .init(x: xPos, y: yPos))
                    }
                }
            }
            
            path.stroke()
            
        }
    }
    
}
