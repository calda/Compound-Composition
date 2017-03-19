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
    @IBOutlet weak var numberRow: UIView!

    
    //MARK: - View Setup
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
       self.numberRow.transform = CGAffineTransform(translationX: 0, y: self.numberRow.frame.height)
    }
    
    
    //MARK: - Fake number row
    
    func keyboardChanged(notification: Notification) {
        let info = notification.userInfo as? [String : Any]
        if let keyboardSize = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (info?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            
            let keyboardTop = keyboardSize.origin.y
            let unavailableSpace = UIScreen.main.bounds.height - keyboardTop
            
            var transform = -unavailableSpace
            
            if transform == 0 {
                //put the row below the screen instead of right at the bottom
                transform = self.numberRow.frame.height
            } else {
                //bring the row on-screen so it feels like part of the keyboard the whole time
                self.numberRow.transform = .identity
            }
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                self.numberRow.transform = CGAffineTransform(translationX: 0, y: transform)
            }, completion: nil)
        }
    }
    
    
    
    //MARK: - User Interaction
    
    
    @IBAction func calculatePressed(_ sender: Any) {
        let text = baseFormulaTextField.text ?? ""
        
        if let formula = Formula.from(input: text).formula {
            let calculation = Calculation(components: [formula])
            
            print(formula)
            print(calculation.percentComposition)
        }
        
        
    }
    
    
    
}
