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
    
    private var underlineView: UIView?
    
    @IBInspectable var underlineColor: UIColor? {
        didSet {
            updateUnderlineView(animated: false)
        }
    }
    
    
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
        
        self.correctPlaceholder()
        self.autocapitalizationType = .allCharacters
        
        if self.keyboardType == .default {
            self.keyboardType = .webSearch
        }
        
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        
        self.updateUnderlineView(animated: false)
    }
    
    func attributedText(for formulaString: String, showingErrors: Bool = false, baseColor: UIColor) -> NSAttributedString {
        let attributedWithSubscripts = formulaString.asChemicalFormula(ofSize: self.font?.pointSize ?? 23)
        let displayString = attributedWithSubscripts.mutableCopy() as! NSMutableAttributedString
        
        let (_, error) = Formula.from(input: displayString.string)
        
        let fullRangeAttributes: [String : Any] = [
            NSForegroundColorAttributeName : baseColor
        ]
        
        let fullRange = NSMakeRange(0, displayString.length)
        displayString.addAttributes(fullRangeAttributes, range: fullRange)
        
        //show any errors as red text
        let errorRangeAttributes: [String : Any] = [
            NSForegroundColorAttributeName : UIColor.red
        ]
        
        func handleErrorRanges(_ ranges: [NSRange]) {
            ranges.forEach { range in
                displayString.setAttributes(errorRangeAttributes, range: range)
            }
        }
        
        switch(error) {
            case .invalidInput(let invalidRanges):
                let ranges = invalidRanges.map{ $0.1 } //map [(String, NSRange)] to [NSRange]
                handleErrorRanges(ranges)
            default: break
        }
        
        //return an immutable object
        return NSAttributedString(attributedString: displayString)
    }
    
    func correctPlaceholder() {
        if let placeholder = self.placeholder ?? self.attributedPlaceholder?.string {
            let placeholderColor = UIColor(white: 0.0, alpha: 0.25)
            self.attributedPlaceholder = self.attributedText(for: placeholder, baseColor: placeholderColor)
        }
    }
    
    
    //MARK: - Interaction
    
    func contentChanged() {
        self.preserveCursorPosition(withChanges: { _ in
            self.attributedText = self.attributedText(for: self.text ?? "", baseColor: .black)
            
            self.layoutIfNeeded()
            self.updateUnderlineView(animated: true)
            self.correctPlaceholder() //sometimes the placeholder's font sizes are changed, so it needs to be corrected
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
            self.attributedText = self.attributedText(for: "\(content)", baseColor: .black)
            
            self.layoutIfNeeded()
            self.updateUnderlineView(animated: true)
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
    
    
    //MARK: - Underline
    
    func updateUnderlineView(animated: Bool) {
        self.borderStyle = .none
        
        if underlineView == nil {
            underlineView = UIView()
            self.addSubview(underlineView!)
        }
        
        guard let underlineView = underlineView else { return }
        underlineView.backgroundColor = underlineColor
        
        var attributedTextShown: NSAttributedString! = self.attributedText
        if attributedTextShown == nil || attributedTextShown?.string == "" {
            attributedTextShown = self.attributedPlaceholder ?? NSAttributedString(string: "")
        }
        
        let contentWidth = attributedTextShown.boundingRect(with: self.frame.size, options: [], context: nil).width
        let underlineWidth = min(contentWidth, self.frame.width)
        
        //calculate offset for text alignment style
        let underlineFrameX: CGFloat
        if self.textAlignment == .right {
            underlineFrameX = self.frame.width - underlineWidth
        } else if self.textAlignment == .center {
            underlineFrameX = (self.frame.width - underlineWidth) / 2.0
        } else {
            underlineFrameX = 0
        }
        
        let newFrame = CGRect(x: underlineFrameX, y: self.frame.height - 2, width: underlineWidth, height: 2.0)
        
        if animated {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                underlineView.frame = newFrame
            }, completion: nil)
            
        } else {
            underlineView.frame = newFrame
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
            let isPartOfNumber = (!isPastCoefficient ? character.isDecimal : false) || character.isInteger
            
            if !isPartOfNumber {
                isPastCoefficient = true //the coefficient ends at the first letter
            }
            
            let attributesForCharacter = (isPastCoefficient && isPartOfNumber) ? subscriptAttributes : normalAttributes
            
            let attributedCharacter = NSAttributedString(string: character, attributes: attributesForCharacter)
            
            attributedString.append(attributedCharacter)
        }
        
        return NSAttributedString(attributedString: attributedString) //return an immutable copy
    }
    
}
