//
//  ViewController.swift
//  Compound Composition
//
//  Created by Cal Stephens on 3/18/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet var formulaTextFields: [FormulaTextField]!
    @IBOutlet weak var baseFormulaTextField: FormulaTextField!
    @IBOutlet weak var numberRow: UIView!
    @IBOutlet weak var numberRowBottom: NSLayoutConstraint!

    
    //MARK: - View Setup
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        self.numberRowBottom.constant = -self.numberRow.frame.height
        self.view.layoutIfNeeded()
    }
    
    
    //MARK: - Fake number row
    
    func keyboardChanged(notification: Notification) {
        let info = notification.userInfo as? [String : Any]
        if let keyboardSize = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (info?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            
            let keyboardTop = keyboardSize.origin.y
            let unavailableSpace = UIScreen.main.bounds.height - keyboardTop
            
            var translation = unavailableSpace
            if translation == 0 {
                //put the row below the screen instead of right at the bottom
                translation = -self.numberRow.frame.height
            }
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                self.numberRowBottom.constant = translation
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    
    //MARK: - User Interaction
    
    @IBAction func numberButtonPressed(_ sender: NumberButton) {
        guard let number = sender.displayNumber else { return }
        if let currentTextField = formulaTextFields.first(where: { $0.isFirstResponder }) {
            currentTextField.simulateKeyboardPress(character: "\(number)")
        }
    }
    
    @IBAction func calculatePressed(_ sender: Any) {
        let text = baseFormulaTextField.text ?? ""
        
        if let formula = Formula.from(input: text).formula {
            let calculation = Calculation(components: [formula])
            
            print(formula)
            print(calculation.percentComposition)
        }
        
    }
    
}
