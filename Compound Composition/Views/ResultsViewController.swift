//
//  ResultsViewController.swift
//  Compound Composition
//
//  Created by Cal Stephens on 4/1/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit
import Charts

class ResultsViewController : UIViewController {
    
    
    //MARK: - Presentation
    
    static func present(in navigationController: UINavigationController?, with calculation: Calculation) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "results") as! ResultsViewController
        controller.calculation = calculation
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - Setup
    
    var calculation: Calculation!
    @IBOutlet weak var pieChartContainer: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        let data = calculation.percentComposition.map { element, percent in
            return PieChartDataEntry(value: percent, label: element.name)
        }
        
        let pieChart = PieChartView()
        pieChartContainer.addSubview(pieChart)
        pieChart.frame = pieChartContainer.bounds
        
        let dataSet = PieChartDataSet(values: data, label: "Percent Composition")
        dataSet.colors = ChartColor.all
        
        pieChart.data = PieChartData(dataSet: dataSet)
    }
    
}

class ChartColor {
    
    static let red = UIColor(red: 0.016, green: 0.779, blue: 0.750, alpha: 1.0)
    static let orange = UIColor(red: 0.066, green: 1.000, blue: 0.829, alpha: 1.0)
    static let yellow = UIColor(red: 0.111, green: 1.000, blue: 1.000, alpha: 1.0)
    static let navy = UIColor(red: 0.583, green: 0.449, blue: 0.310, alpha: 1.0)
    static let magenta = UIColor(red: 0.783, green: 0.610, blue: 0.680, alpha: 1.0)
    static let teal = UIColor(red: 0.544, green: 0.540, blue: 0.449, alpha: 1.0)
    static let green = UIColor(red: 0.402, green: 0.779, blue: 0.680, alpha: 1.0)
    static let mint = UIColor(red: 0.466, green: 0.860, blue: 0.629, alpha: 1.0)
    static let gray = UIColor(red: 0.511, green: 0.100, blue: 0.550, alpha: 1.0)
    static let forest = UIColor(red: 0.375, green: 0.439, blue: 0.310, alpha: 1.0)
    static let purple = UIColor(red: 0.702, green: 0.560, blue: 0.639, alpha: 1.0)
    static let brown = UIColor(red: 0.069, green: 0.449, blue: 0.310, alpha: 1.0)
    static let plum = UIColor(red: 0.833, green: 0.460, blue: 0.310, alpha: 1.0)
    static let watermelon = UIColor(red: 0.994, green: 0.610, blue: 0.850, alpha: 1.0)
    static let lime = UIColor(red: 0.205, green: 0.810, blue: 0.689, alpha: 1.0)
    static let pink = UIColor(red: 0.908, green: 0.569, blue: 0.829, alpha: 1.0)
    static let maroon = UIColor(red: 0.011, green: 0.680, blue: 0.400, alpha: 1.0)
    static let coffee = UIColor(red: 0.069, green: 0.340, blue: 0.560, alpha: 1.0)
    static let blue = UIColor(red: 0.622, green: 0.560, blue: 0.509, alpha: 1.0)
    static let black = UIColor(red: 0.000, green: 0.000, blue: 0.250, alpha: 1.0)
    
    static let all = [red, orange, yellow, navy, magenta, teal, green, mint,
                      gray, forest, purple, brown, plum, watermelon, lime,
                      pink, maroon, coffee, blue, black]
    
}
