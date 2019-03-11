//
//  ViewController.swift
//  ChartsApp
//
//  Created by Ruslan on 3/11/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let path = Bundle.main.path(forResource: "chart_data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let charts = try JSONDecoder().decode(ChartsResponseModel.self, from: data)
                print(charts)
            } catch {
                print(error.localizedDescription)
            }
        }
    }


}

