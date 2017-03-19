//
//  Calculation.swift
//  Compound Composition
//
//  Created by Cal Stephens on 3/19/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

struct Calculation {
    
    var components: [Formula]
    
    
    //MARK: - Main calculation
    
    var percentComposition: [(element: Element, percent: Double)] {
        
        //find total element counts across all components
        var composition = [(element: Element, mass: Double)]()
        
        func incrementMass(of element: Element, by additional: Double) {
            if let existingIndex = composition.index(where: { $0.element == element }) {
                let previousCount = composition[existingIndex].mass
                composition[existingIndex] = (element, previousCount + additional)
            } else {
                composition.append((element, additional))
            }
        }
        
        for component in components {
            for (element, count) in component.elements {
                let mass = element.weight * Double(count) * component.coefficient
                incrementMass(of: element, by: mass)
            }
        }
        
        //calculate percent composition
        let totalMassInSystem = composition.reduce(0) { partial, item in
            return partial + item.mass
        }
        
        return composition.map { element, mass in
            
            if totalMassInSystem == 0 {
                return (element, 0)
            }
            
            let percentageOfTotal = mass / totalMassInSystem
            return (element, percentageOfTotal)
        }
        
    }
    
}
