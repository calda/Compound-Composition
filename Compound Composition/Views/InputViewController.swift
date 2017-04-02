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
    
    var currentResponder: FormulaTextField? {
        return formulaTextFields.first(where: { field in
            return field.isFirstResponder
        })
    }
    
    @IBOutlet weak var baseFormulaTextField: FormulaTextField!
    @IBOutlet weak var numberRow: UIView!
    @IBOutlet weak var numberRowBottom: NSLayoutConstraint!
    
    @IBOutlet weak var additionalComponentsScrollView: UIScrollView!
    @IBOutlet weak var additionalComponentsView: UIView!
    @IBOutlet weak var deleteComponentButton: UIButton!
    
    @IBOutlet weak var hydrationTextField: FormulaTextField!
    @IBOutlet weak var hydrationFormulaLabel: UILabel!
    

    
    //MARK: - View Setup
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        self.numberRowBottom.constant = -self.numberRow.frame.height
        self.view.layoutIfNeeded()
        
        self.hydrationFormulaLabel.attributedText = "H2O".asChemicalFormula(ofSize: 30)
        self.deleteComponentButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.baseFormulaTextField.becomeFirstResponder()
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
        }
    }
    
    
    //MARK: - Adding and Deleting Additional Components
    
    private var additionalComponentTextFields: [FormulaTextField] {
        return self.formulaTextFields.filter({ $0.superview == self.additionalComponentsView })
    }
    
    private var rightmostAdditionalComponent: (textField: FormulaTextField, constraint: NSLayoutConstraint?)? {
        let rightmostTextField = self.additionalComponentTextFields.max(by: { label1, label2 in
            return label1.frame.minX < label2.frame.minX
        })
        
        let constraint = self.additionalComponentsView.constraints.first(where: {
            if ($0.firstItem as? NSObject != rightmostTextField) && ($0.secondItem as? NSObject != rightmostTextField) {
                return false
            }
            
            return ($0.firstItem as? NSObject == self.additionalComponentsView && $0.firstAttribute == .trailing)
                || ($0.secondItem as? NSObject == self.additionalComponentsView && $0.secondAttribute == .trailing)
        })
        
        if let textField = rightmostTextField {
            return (textField, constraint)
        } else {
            return nil
        }
    }
    
    @IBAction func addAdditionalComponent(_ sender: Any) {
        guard let (rightmostComponent, rightConstraint) = self.rightmostAdditionalComponent else { return }
        
        rightConstraint?.isActive = false
        
        //build a new textfield
        let newTextField = FormulaTextField(frame: .zero)
        newTextField.translatesAutoresizingMaskIntoConstraints = false
        newTextField.attributedPlaceholder = rightmostComponent.attributedPlaceholder
        newTextField.font = rightmostComponent.font
        newTextField.underlineColor = rightmostComponent.underlineColor
        
        self.additionalComponentsView.addSubview(newTextField)
        self.formulaTextFields.append(newTextField)
        
        //build new constraints
        let constraints = [
            NSLayoutConstraint(item: newTextField, attribute: .leading, relatedBy: .equal, toItem: rightmostComponent, attribute: .trailing, multiplier: 1, constant: 15),
        
            NSLayoutConstraint(item: newTextField, attribute: .trailing, relatedBy: .equal, toItem: self.additionalComponentsView, attribute: .trailing, multiplier: 1, constant: -15),
        
            NSLayoutConstraint(item: newTextField, attribute: .centerY, relatedBy: .equal, toItem: rightmostComponent, attribute: .centerY, multiplier: 1, constant: 0)
        ]
        
        let zeroWidthConstraint = NSLayoutConstraint(item: newTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        
        self.additionalComponentsView.addConstraints(constraints)
        newTextField.addConstraint(zeroWidthConstraint)
        self.additionalComponentsScrollView.layoutIfNeeded()
        newTextField.alpha = 0.0
        newTextField.setup()
        
        //animate
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.0, options: [], animations: {
            
            newTextField.removeConstraint(zeroWidthConstraint)
            self.additionalComponentsScrollView.layoutIfNeeded()
            newTextField.setup()
            newTextField.alpha = 1.0
            
            self.deleteComponentButton.alpha = 1.0
        }, completion: nil)
    }
    
    @IBAction func deleteAdditionalComponent(_ sender: Any) {
        guard let (rightmostComponent, rightConstraint) = self.rightmostAdditionalComponent else { return }
        
        let zeroWidthConstraint = NSLayoutConstraint(item: rightmostComponent, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        rightmostComponent.addConstraint(zeroWidthConstraint)
        
        rightConstraint?.constant = 0
        self.deleteComponentButton.isEnabled = false
        
        //animate away the text field
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.0, options: [], animations: {
            
            self.additionalComponentsScrollView.layoutIfNeeded()
            rightmostComponent.alpha = 0.0
            
            //keep the user from deleting the first additional component
            if self.additionalComponentTextFields.count == 2 {
                self.deleteComponentButton.alpha = 0.0
                self.deleteComponentButton.isEnabled = true
            }
            
        }, completion: { _ in
            self.deleteComponentButton.isEnabled = true
            
            //remove the text field and update constraints
            rightmostComponent.removeFromSuperview()
            if let index = self.formulaTextFields.index(of: rightmostComponent) {
                self.formulaTextFields.remove(at: index)
            }
            
            guard let (newRightmostComponent, _) = self.rightmostAdditionalComponent else { return }
            
            let newRightConstraint = NSLayoutConstraint(item: newRightmostComponent, attribute: .trailing, relatedBy: .equal, toItem: self.additionalComponentsView, attribute: .trailing, multiplier: 1, constant: -15)
            self.additionalComponentsView.addConstraint(newRightConstraint)
            
            self.additionalComponentsScrollView.layoutIfNeeded()
        })
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
