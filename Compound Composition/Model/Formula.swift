//
//  Formula.swift
//  Compound Composition
//
//  Created by Cal Stephens on 3/18/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import Foundation

struct Formula {
    
    
    //MARK: - Parsing
    
    public static func from(input: String) -> (formula: Formula?, error: ParsingError) {
        var characters = input.characterArray
        
        //in-progress elements
        var coefficient: Double?
        var elements = [(element: Element, count: Int)]()
        var inProgressElement: Element?
        
        var previousFocus: String = ""
        
        //parse per-character
        for (index, character) in characters.enumerated() {
            if character == " " { continue }
            var currentFocus = previousFocus + character
            
            func isLastCharacter() -> Bool {
                return nextFocus() == nil
            }
            
            //find the next focus, *ignoring spaces*
            func nextFocus() -> String? {
                var nextFocus = currentFocus
                
                var indexOffset = 0
                while nextFocus.lengthOfBytes(using: .utf8) == currentFocus.lengthOfBytes(using: .utf8) {
                    indexOffset += 1
                    
                    if index + indexOffset >= characters.count {
                        return nil
                    } else {
                        nextFocus = (currentFocus + characters[index + indexOffset]).replacingOccurrences(of: " ", with: "")
                    }
                }
                
                return nextFocus
            }
            
            func focusRange() -> NSRange {
                let focusLength = currentFocus.lengthOfBytes(using: .utf8)
                return NSMakeRange(index - (focusLength - 1), focusLength)
            }
            
            //searching for coefficient
            if coefficient == nil {
                
                if currentFocus.characters.last == "." {
                    previousFocus = currentFocus
                    continue //if there's a decimal, keep waiting for coefficient
                }
                
                if !currentFocus.isDouble && previousFocus.isDouble {
                    coefficient = Double(previousFocus)
                    currentFocus = character
                } else if !currentFocus.isDouble {
                    coefficient = 1.0
                } else {
                    previousFocus = currentFocus
                    continue //keep waiting for coefficient
                }
                
            }
            
            
            //build existing element
            if let element = inProgressElement { //if inProgressElement is not nil
                
                let nextStepIsNotInteger = !currentFocus.isInteger || isLastCharacter()
                let integerString = (isLastCharacter() && currentFocus.isInteger) ? currentFocus : previousFocus
                
                if nextStepIsNotInteger && integerString.isInteger {
                    
                    let count = Int(integerString)!
                    
                    elements.append((element: element, count: count))
                    currentFocus = (integerString == previousFocus) ? character : ""
                    inProgressElement = nil
                    
                } else if !currentFocus.isInteger {
                    //commit the element if another element symbol starts
                    elements.append((element: element, count: 1))
                    inProgressElement = nil
                }
                
            }
            
            //searching for new element to build
            if inProgressElement == nil {
                
                let nextCharacter = nextFocus()?.characterArray.last ?? ""
                
                if let newElement = Element.with(symbol: currentFocus) {
                    
                    //if this is a single-letter element but the next focus also yields a valid element, wait for that one
                    let waitForNext = currentFocus.isSingleCharacter
                        && !isLastCharacter()
                        && nextCharacter.isLowercaseLetter == true //look ahead to the next letter
                    
                    if !waitForNext {
                        inProgressElement = newElement
                        
                        if isLastCharacter() {
                            elements.append((element: newElement, count: 1))
                        }
                        
                        currentFocus = ""
                    }
                    
                } else if currentFocus.isEmpty || (currentFocus.isUppercaseLetter && nextCharacter.isLowercaseLetter) {
                    //wait for two-character element before throwing an error
                } else {
                    return (nil, error: .invalidElement(currentFocus, focusRange()))
                }
                
            }
            
            previousFocus = currentFocus
        }
        
        
        //build the final object
        if elements.count == 0 {
            return (nil, error: .noElements)
        }
        
        let formula = Formula(originalString: input, coefficient: coefficient ?? 1, elements: elements)
        return (formula, error: .none)
        
        
        
        //return (nil, .unknown)
    }
    
    public enum ParsingError {
        case none
        case invalidElement(String, NSRange)
        case noElements
        
        var isNone: Bool {
            switch(self) {
                case .none: return true
                default: return false
            }
        }
    }
    
    
    //MARK: - Properties
    
    var originalString: String
    var coefficient: Double
    var elements: [(element: Element, count: Int)]
    
    
}


//MARK: - Parsing Helpers

extension String {
    
    var characterArray: [String] {
        return Array(self.characters).map { "\($0)" }
    }

    
    //MARK: - Strings
    
    var isSingleCharacter: Bool {
        return self.lengthOfBytes(using: .utf8) == 1
    }
    
    var isLowercaseLetter: Bool {
        return self.isSingleCharacter && "abcdefghijklmnopqrstuvwxyz".contains(self)
    }
    
    var isUppercaseLetter: Bool {
        return !self.isLowercaseLetter
    }

    
    //MARK: - Numbers
    
    var isInteger: Bool {
        return Int(self) != nil
    }
    
    var isDouble: Bool {
        return Double(self) != nil
    }
    
}
