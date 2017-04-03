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
            return PieChartDataEntry(value: percent, label: element.name, data: element as AnyObject)
        }
        
        let pieChart = PieChartView()
        pieChartContainer.addSubview(pieChart)
        pieChart.frame = pieChartContainer.bounds
        pieChart.maxAngle = 180.0
        pieChart.rotationAngle = 180.0
        pieChart.rotationEnabled = false
        
        let dataSet = PieChartDataSet(values: data, label: nil)
        dataSet.colors = ChartColor.all
        
        dataSet.valueFont = UIFont(name: ".SFUIDisplay-Bold", size: 15) ?? .systemFont(ofSize: 15)
        dataSet.entryLabelFont = UIFont(name: ".SFUIDisplay-Medium", size: 12) ?? .systemFont(ofSize: 12)
        dataSet.selectionShift = 0
        dataSet.valueFormatter = ElementFormatter()
        
        pieChart.drawEntryLabelsEnabled = false
        pieChart.data = PieChartData(dataSet: dataSet)
        pieChart.legend.enabled = false
    }
    
}

class ElementFormatter : NSObject, IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return (entry.data as? Element)?.symbol ?? ""
    }
    
}
