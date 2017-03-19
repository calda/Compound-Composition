//
//  ViewController.swift
//  Compound Composition
//
//  Created by Cal Stephens on 3/18/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet weak var baseFormulaTextField: UITextField!

    @IBAction func calculatePressed(_ sender: Any) {
        let text = baseFormulaTextField.text ?? ""
        
        print(Formula.from(input: text))
    }
    
    
    
}
