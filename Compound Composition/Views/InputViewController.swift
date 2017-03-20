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


//MARK: - String + AttributedString helper

extension String {
    
    func asChemicalFormula(ofSize fontSize: CGFloat) -> NSAttributedString {
        
        let normalAttributes: [String : Any] = [
            NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)
        ]
        
        let subscriptAttributes: [String : Any] = [
            NSFontAttributeName : UIFont.systemFont(ofSize: fontSize * 0.7),
            NSBaselineOffsetAttributeName : NSNumber(floatLiteral: -1.5)
        ]
        
        //build the attributed string
        let attributedString = NSMutableAttributedString()
        var isPastCoefficient = false //all numbers are in subscript except for the coefficient
        
        for character in self.characterArray {
            if character.isLetter {
                isPastCoefficient = true //the coefficient ends at the first letter
            }
            
            let attributesForCharacter = (!isPastCoefficient || character.isLetter) ? normalAttributes : subscriptAttributes
            
            let attributedCharacter = NSAttributedString(string: character, attributes: attributesForCharacter)
            
            attributedString.append(attributedCharacter)
        }
        
        return NSAttributedString(attributedString: attributedString) //return an immutable copy
    }
    
    
}
