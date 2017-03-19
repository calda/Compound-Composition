//
//  Parsing_Tests.swift
//  Parsing-Tests
//
//  Created by Cal Stephens on 3/19/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import XCTest

class Parsing_Tests: XCTestCase {
    
    func testValidCases() {
        
        let cases: [String : (coefficient: Double, elements: [(count: Int, element: Element)])] = [
            "H" : (coefficient: 1, elements: [(1, .hydrogen)]),
            "H2" : (coefficient: 1, elements: [(2, .hydrogen)]),
            "He2" : (coefficient: 1, elements: [(2, .helium)]),
            "10.0 U" : (coefficient: 10, elements: [(1, .uranium)]),
            "1.00 U" : (coefficient: 1, elements: [(1, .uranium)]),
            "5 H H" : (coefficient: 5, elements: [(1, .hydrogen), (1, .hydrogen)]),
            "5.0 H He" : (coefficient: 5, elements: [(1, .hydrogen), (1, .helium)]),
            "55.672 H5O" : (coefficient: 55.672, elements: [(5, .hydrogen), (1, .oxygen)]),
            "5H5O5" : (coefficient: 5, elements: [(5, .hydrogen), (5, .oxygen)]),
            "H5O5" : (coefficient: 1, elements: [(5, .hydrogen), (5, .oxygen)]),
            "CU" : (coefficient: 1, elements: [(1, .carbon), (1, .uranium)]),
            "Cu" : (coefficient: 1, elements: [(1, .copper)]),
            "122Cu" : (coefficient: 122, elements: [(1, .copper)]),
            "122    C   u   " : (coefficient: 122, elements: [(1, .copper)]),
            "5.0Cu6" : (coefficient: 5, elements: [(6, .copper)]),
            "5    . 0    C   u  6  " : (coefficient: 5, elements: [(6, .copper)])
        ]
        
        for (input, answer) in cases {
            let (possibleFormula, error) = Formula.from(input: input)
            
            guard let formula = possibleFormula else {
                XCTAssertTrue(false, "Formula \"\(input)\" failed to parse. (error=\(error))")
                continue
            }
            
            XCTAssertTrue(error.isNone, "Formula \"\(input)\" yielded an error despite parsing successfully")
            
            XCTAssertEqual(formula.coefficient, answer.coefficient, "Formula \"\(input)\" produced the wrong coefficient (\(formula.coefficient))")
            
            XCTAssert(formula.elements.count == answer.elements.count, "Formula \"\(input)\" has the wrong number of elements (\(formula.elements.count))")
            
            for i in 0 ..< formula.elements.count {
                let (givenElement, givenCount) = formula.elements[i]
                let (answerCount, answerElement) = answer.elements[i]
                
                XCTAssert(givenElement == answerElement, "Formula \"\(input)\" yielded the wrong element at index \(i) (\(givenElement) instead of \(answerElement))")
                
                XCTAssert(givenElement == answerElement, "Formula \"\(input)\" yielded the wrong count for \(answerElement) at index \(i) (\(givenCount) instead of \(answerCount))")
            }
        }
        
    }
    
    func testInvalidElementNamesYieldCorrectRange() {
        
        let cases: [String : NSRange] = [
            "Hy" : NSMakeRange(0, 2),
            "HHy" : NSMakeRange(1, 2),
            "HeHyHo" : NSMakeRange(2, 2),
            "HZ" : NSMakeRange(1, 1),
            "HZH" : NSMakeRange(1, 1),
            "HZHe" : NSMakeRange(1, 1)
        ]
        
        for (input, invalidRange) in cases {
            let (formula, error) = Formula.from(input: input)
            
            XCTAssertNil(formula, "Formula \"\(input)\" was supposed to fail, but didn't.")
            
            switch(error) {
                case .invalidElement(_, let range):
                    XCTAssert(range == invalidRange, "Formula \"\(input)\" yield the wrong invalid range \(range)")
                default:
                    XCTAssertTrue(false, "Formula \"\(input)\" didn't yield a .invalidRange error")
            }
            
        }
        
    }
    
}


//MARK: - Helpers

extension NSRange : CustomStringConvertible, Equatable {
    
    public var description: String {
        return "(\(self.location),\(self.length))"
    }
    
    public static func ==(left: NSRange, right: NSRange) -> Bool {
        return left.length == right.length && left.location == right.location
    }
    
}
