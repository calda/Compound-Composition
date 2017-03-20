//
//  FormulaInputField.swift
//  Compound Composition
//
//  Created by Cal Stephens on 3/20/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

@IBDesignable
class FormulaTextField : UITextField {
    
    
    //MARK: - Setup
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        self.addTarget(self, action: #selector(self.contentChanged), for: .editingChanged)
        
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = self.attributedText(for: placeholder)
        }
        
        self.autocapitalizationType = .allCharacters
        self.keyboardType = .webSearch //so the . is visible
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
    
    func attributedText(for formulaString: String) -> NSAttributedString {
        return formulaString.asChemicalFormula(ofSize: self.font?.pointSize ?? 23)
    }
    
    
    //MARK: - Interaction
    
    func contentChanged() {
        self.preserveCursorPosition(withChanges: { _ in
            self.attributedText = self.attributedText(for: self.text ?? "")
            return .preserveCursor
        })
    }
    
    func simulateKeyboardPress(character: String) {
        self.preserveCursorPosition(withChanges: { originalCursorPositon in
            
            let content = ((self.text ?? "") as NSString).mutableCopy() as! NSMutableString
            var indexForNewLetter = content.length
            
            if let cursorPosition = originalCursorPositon ?? self.position(from: self.endOfDocument, offset: 0) {
                indexForNewLetter = self.offset(from: self.beginningOfDocument, to: cursorPosition)
            }
            
            content.insert(character, at: indexForNewLetter)
            self.attributedText = self.attributedText(for: "\(content)")
            
            return .incrementCursor
            
        })
    }
    
    func preserveCursorPosition(withChanges mutatingFunction: (UITextPosition?) -> (ShouldChangeCursor)) {
        
        //save the cursor positon
        var cursorPosition: UITextPosition? = nil
        if let selectedRange = self.selectedTextRange {
            let offset = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
            cursorPosition = self.position(from: self.beginningOfDocument, offset: offset)
        }
        
        //make mutaing changes that may reset the cursor position
        let shouldChangeCursor = mutatingFunction(cursorPosition)
        
        //restore the cursor
        if var cursorPosition = cursorPosition {
            
            if shouldChangeCursor == .incrementCursor {
                cursorPosition = self.position(from: cursorPosition, offset: 1) ?? cursorPosition
            }
            
            if let range = self.textRange(from: cursorPosition, to: cursorPosition) {
                self.selectedTextRange = range
            }
        }
        
    }
    
    enum ShouldChangeCursor {
        case incrementCursor
        case preserveCursor
    }
    
    
    
}
