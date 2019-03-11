//
//  ViewController.swift
//  ChartsApp
//
//  Created by Ruslan on 3/11/19.
//  Copyright © 2019 leshchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var chartsView: ChartsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartsView.chartsData = Utils.fetchChartsData()
        chartsView.setNeedsLayout()
    }


}

