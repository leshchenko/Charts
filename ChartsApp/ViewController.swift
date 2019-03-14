//
//  ViewController.swift
//  ChartsApp
//
//  Created by Ruslan on 3/11/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var chartsView: ChartsNavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let chartsData = Utils.fetchChartsData()
        chartsView.update(chartData: chartsData?[3])
        chartsView.setNeedsLayout()
    }


}

