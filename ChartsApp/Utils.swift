//
//  Utils.swift
//  ChartsApp
//
//  Created by Ruslan on 3/11/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import Foundation
class Utils {
    
    static func fetchChartsData() -> ChartsResponseModel? {
        if let path = Bundle.main.path(forResource: "chart_data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let charts = try JSONDecoder().decode(ChartsResponseModel.self, from: data)
                return charts
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
}
