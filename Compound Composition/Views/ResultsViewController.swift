//
//  ResultsViewController.swift
//  Compound Composition
//
//  Created by Cal Stephens on 4/1/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class ResultsViewController : UIViewController {
    
    
    //MARK: - Presentation
    
    static func present(in navigationController: UINavigationController?, with calculation: Calculation) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "results") as! ResultsViewController
        controller.calculation = calculation
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - Setup
    
    var calculation: Calculation!
    
}
