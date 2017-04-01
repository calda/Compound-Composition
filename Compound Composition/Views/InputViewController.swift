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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var additionalComponents = [""]

    
    //MARK: - View Setup
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        self.numberRowBottom.constant = -self.numberRow.frame.height
        self.view.layoutIfNeeded()
        //self.updateTableViewHeight(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.baseFormulaTextField.becomeFirstResponder()
    }
    
    
    //MARK: - Fake number row
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
    
    
    //MARK: - User Interaction
    
    @IBAction func numberButtonPressed(_ sender: NumberButton) {
        guard let number = sender.displayNumber else { return }
        if let currentTextField = self.currentResponder {
            currentTextField.simulateKeyboardPress(character: "\(number)")
        }
    }
    
}
