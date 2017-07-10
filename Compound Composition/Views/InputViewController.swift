//
//  ViewController.swift
//  Compound Composition
//
//  Created by Cal Stephens on 3/18/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

//use something like this for searching by name:
//http://chemspipy.readthedocs.io/en/latest/

class InputViewController: UIViewController {

    @IBOutlet var formulaTextFields: [FormulaTextField]!
    
    var currentResponder: FormulaTextField? {
        return formulaTextFields.first(where: { field in
            return field.isFirstResponder
        })
    }
    
    @IBOutlet weak var baseFormulaTextField: FormulaTextField!
    @IBOutlet weak var numberRow: UIView!
    @IBOutlet weak var numberRowBottom: NSLayoutConstraint!
    
    @IBOutlet weak var hydrationTextField: FormulaTextField!
    @IBOutlet weak var hydrationFormulaLabel: UILabel!
    
    
    //MARK: - View Setup
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.keyboardChanged(notification:)),
            name: .UIKeyboardWillChangeFrame, object: nil)
        
        self.numberRowBottom.constant = -self.numberRow.frame.height
        self.view.layoutIfNeeded()
        
        self.hydrationFormulaLabel.attributedText = "H2O".asChemicalFormula(ofSize: 30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.formulaTextFields.forEach { textField in
            textField.setup()
            textField.addTarget(self,
                action: #selector(self.textFieldContentDidChange(_:)),
                for: .editingChanged)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.baseFormulaTextField.becomeFirstResponder()
        
        //ResultsViewController.present(in: self.navigationController, with: Calculation(components: [Formula.from(input: "C6H12O6").formula!]))
    }
    
    
    //MARK: - Manage the Number Row
    
    private var previousKeyboardType: UIKeyboardType = .default
    
    func keyboardChanged(notification: Notification) {
        let info = notification.userInfo as? [String : Any]
        if let keyboardSize = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           var duration = (info?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            
            let keyboardTop = keyboardSize.origin.y
            let unavailableSpace = UIScreen.main.bounds.height - keyboardTop
            
            var translation = unavailableSpace
            if translation == 0 {
                //put the row below the screen instead of right at the bottom
                translation = -self.numberRow.frame.height
            }

            
            let currentKeyboardType = self.currentResponder?.keyboardType ?? .default
            
            //if switching to or from the decimal pad, don't animate the number bar
            if currentKeyboardType == .decimalPad || previousKeyboardType == .decimalPad {
                duration = 0
            }
            
            //if the decimal pad is visible, hide the number row
            if currentKeyboardType == .decimalPad {
                translation = 0
            }
            
            self.previousKeyboardType = currentKeyboardType
            

            func updatePositions() {
                self.numberRowBottom.constant = translation
                self.view.layoutIfNeeded()
            }
            
            //if the duration is zero, force there to be no animation
            //this function must be called from an animation block, because UIKit.animate blocks have no effect
            if duration == 0 {
                DispatchQueue.main.async {
                    updatePositions()
                }
            } else {
                //animate normally
                //(this function must called from an animation block, because this works no problem)
                updatePositions()
            }
        }
    }
    
    @IBAction func numberButtonPressed(_ sender: NumberButton) {
        guard let number = sender.displayNumber else { return }
        if let currentTextField = self.currentResponder {
            currentTextField.simulateKeyboardPress(character: "\(number)")
            self.textFieldContentDidChange(currentTextField)
        }
    }
    
    
    //MARK: - User Interaction
    
    func textFieldContentDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        let titleStackView = textField.superview?.subviews.flatMap { $0 as? UIStackView }.first
        
        UIView.animate(withDuration: 0.5) {
            titleStackView?.alpha = (text.isEmpty) ? 1.0 : 0.5
        }
    }
    
    
    //MARK: - Calculate
    
    @IBAction func calculatePressed(_ sender: Any) {
        var formulas = [Formula]()
        
        for formulaTextField in formulaTextFields {
            
            var textFieldText = formulaTextField.text ?? ""
            if textFieldText.isEmpty { continue }
            
            if formulaTextField == hydrationTextField {
                textFieldText += " H20"
            }
            
            let (formula, error) = Formula.from(input: textFieldText)
            
            switch(error) {
                case .invalidInput(let invalidElements):
                    parsingFailed(at: invalidElements[0].0)
                    return
                case .noElements:
                    continue
                case .none:
                    if let formula = formula {
                        formulas.append(formula)
                    }
            }
        }
        
        parsingSucceeded(with: formulas)
    }
    
    func parsingFailed(at invalidElement: String) {
        let alert = UIAlertController(title: "Invalid Element", message: "\"\(invalidElement)\" is not an element.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func parsingSucceeded(with formulas: [Formula]) {
        if formulas.count == 0 {
            let alert = UIAlertController(title: "No Elements", message: "You must enter at least one element.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.currentResponder?.resignFirstResponder()
        
        let calculation = Calculation(components: formulas)
        ResultsViewController.present(in: self.navigationController, with: calculation)
    }
    
}
