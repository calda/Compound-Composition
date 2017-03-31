//
//  ViewController.swift
//  Compound Composition
//
//  Created by Cal Stephens on 3/18/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var formulaTextFields: [FormulaTextField]!
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
        self.updateTableViewHeight(animated: false)
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
    
    @IBAction func addComponentPressed(_ sender: Any) {
        self.addComponent()
    }
    
    @IBAction func calculatePressed(_ sender: Any) {
        let text = baseFormulaTextField.text ?? ""
        
        if let formula = Formula.from(input: text).formula {
            let calculation = Calculation(components: [formula])
            
            print(formula)
            print(calculation.percentComposition)
        }
        
    }


    //MARK: - Additional Components Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.additionalComponents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let currentText = self.additionalComponents[index]
        
        let isOnlyCell = (self.additionalComponents.count == 1)
        let identifier = isOnlyCell ? "component" : "componentWithDelete"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ComponentInputCell
        self.formulaTextFields.append(cell.formulaTextField)
        
        //closures for cell
        func onCellContentChanged(to newContent: String) {
            self.additionalComponents[index] = newContent
        }
        
        func onCellDeleteButtonPressed() {
            //handle delete
        }
        
        //decorate and return
        cell.decorate(with: currentText, onContentChanged: onCellContentChanged, onDeletePressed: onCellDeleteButtonPressed)
        return cell
    }
    
    func addComponent() {
        self.additionalComponents.append("")
        self.tableView.reloadData()
        self.updateTableViewHeight(animated: true)
    }
    
    func updateTableViewHeight(animated: Bool) {
        let cellHeight: CGFloat = 75.0
        let totalHeight = cellHeight * CGFloat(self.additionalComponents.count)
        self.tableViewHeight.constant = totalHeight
        
        if animated {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
}

class ComponentInputCell : UITableViewCell {
    
    @IBOutlet weak var formulaTextField: FormulaTextField!
    @IBOutlet weak var deleteButton: UIButton?
    
    var onContentChanged: ((String) -> ())?
    var onDeletePressed: (() -> ())?
    
    //setup
    
    func decorate(with content: String?, onContentChanged: ((String) -> ())?, onDeletePressed: (() -> ())?) {
        self.formulaTextField.text = content ?? ""
        self.onContentChanged = onContentChanged
        self.onDeletePressed = onDeletePressed
    }
    
    //user interaction
    
    @IBAction func textFieldContentChanged(_ sender: FormulaTextField) {
        self.onContentChanged?(self.formulaTextField?.text ?? "")
    }
    
    @IBAction func deleteButtonPressed() {
        self.onDeletePressed?()
    }
    
}
