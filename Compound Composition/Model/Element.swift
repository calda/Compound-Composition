//
//  File.swift
//  Compound Composition
//
//  Created by Cal Stephens on 3/18/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

struct Element : Hashable, CustomStringConvertible {
    
    
    //MARK: - Public Constants
    
    public static let hydrogen = Element.with(symbol: "H")!
    public static let helium = Element.with(symbol: "He")!
    public static let oxygen = Element.with(symbol: "O")!
    public static let carbon = Element.with(symbol: "C")!
    public static let copper = Element.with(symbol: "Cu")!
    public static let uranium = Element.with(symbol: "U")!
    
    public static let all = [
        Element(named: "Hydrogen", symbol: "H", weight: 1.0079),
        Element(named: "Helium", symbol: "He", weight: 4.0026),
        Element(named: "Lithium", symbol: "Li", weight: 6.941),
        Element(named: "Beryllium", symbol: "Be", weight: 9.0122),
        Element(named: "Boron", symbol: "B", weight: 10.811),
        Element(named: "Carbon", symbol: "C", weight: 12.0107),
        Element(named: "Nitrogen", symbol: "N", weight: 14.0067),
        Element(named: "Oxygen", symbol: "O", weight: 15.9994),
        Element(named: "Fluorine", symbol: "F", weight: 18.9984),
        Element(named: "Neon", symbol: "Ne", weight: 20.1797),
        Element(named: "Sodium", symbol: "Na", weight: 22.9897),
        Element(named: "Magnesium", symbol: "Mg", weight: 24.305),
        Element(named: "Aluminum", symbol: "Al", weight: 26.9815),
        Element(named: "Silicon", symbol: "Si", weight: 28.0855),
        Element(named: "Phosphorus", symbol: "P", weight: 30.9738),
        Element(named: "Sulfur", symbol: "S", weight: 32.065),
        Element(named: "Chlorine", symbol: "Cl", weight: 35.453),
        Element(named: "Argon", symbol: "Ar", weight: 39.948),
        Element(named: "Potassium", symbol: "K", weight: 39.0983),
        Element(named: "Calcium", symbol: "Ca", weight: 40.078),
        Element(named: "Scandium", symbol: "Sc", weight: 44.9559),
        Element(named: "Titanium", symbol: "Ti", weight: 47.867),
        Element(named: "Vanadium", symbol: "V", weight: 50.9415),
        Element(named: "Chromium", symbol: "Cr", weight: 51.9961),
        Element(named: "Manganese", symbol: "Mn", weight: 54.938),
        Element(named: "Iron", symbol: "Fe", weight: 55.845),
        Element(named: "Cobalt", symbol: "Co", weight: 58.9332),
        Element(named: "Nickel", symbol: "Ni", weight: 58.6934),
        Element(named: "Copper", symbol: "Cu", weight: 63.546),
        Element(named: "Zinc", symbol: "Zn", weight: 65.39),
        Element(named: "Gallium", symbol: "Ga", weight: 69.723),
        Element(named: "Germanium", symbol: "Ge", weight: 72.64),
        Element(named: "Arsenic", symbol: "As", weight: 74.9216),
        Element(named: "Selenium", symbol: "Se", weight: 78.96),
        Element(named: "Bromine", symbol: "Br", weight: 79.904),
        Element(named: "Krypton", symbol: "Kr", weight: 83.8),
        Element(named: "Rubidium", symbol: "Rb", weight: 85.4678),
        Element(named: "Strontium", symbol: "Sr", weight: 87.62),
        Element(named: "Yttrium", symbol: "Y", weight: 88.9059),
        Element(named: "Zirconium", symbol: "Zr", weight: 91.224),
        Element(named: "Niobium", symbol: "Nb", weight: 92.9064),
        Element(named: "Molybdenum", symbol: "Mo", weight: 95.94),
        Element(named: "Technetium", symbol: "Tc", weight: 98.0),
        Element(named: "Ruthenium", symbol: "Ru", weight: 101.07),
        Element(named: "Rhodium", symbol: "Rh", weight: 102.9055),
        Element(named: "Palladium", symbol: "Pd", weight: 106.42),
        Element(named: "Silver", symbol: "Ag", weight: 107.8682),
        Element(named: "Cadmium", symbol: "Cd", weight: 112.411),
        Element(named: "Indium", symbol: "In", weight: 114.818),
        Element(named: "Tin", symbol: "Sn", weight: 118.71),
        Element(named: "Antimony", symbol: "Sb", weight: 121.76),
        Element(named: "Tellurium", symbol: "Te", weight: 127.6),
        Element(named: "Iodine", symbol: "I", weight: 126.9045),
        Element(named: "Xenon", symbol: "Xe", weight: 131.293),
        Element(named: "Cesium", symbol: "Cs", weight: 132.9055),
        Element(named: "Barium", symbol: "Ba", weight: 137.327),
        Element(named: "Lanthanum", symbol: "La", weight: 138.9055),
        Element(named: "Cerium", symbol: "Ce", weight: 140.116),
        Element(named: "Praseodymium", symbol: "Pr", weight: 140.9077),
        Element(named: "Neodymium", symbol: "Nd", weight: 144.24),
        Element(named: "Promethium", symbol: "Pm", weight: 145.0),
        Element(named: "Samarium", symbol: "Sm", weight: 150.36),
        Element(named: "Europium", symbol: "Eu", weight: 151.964),
        Element(named: "Gadolinium", symbol: "Gd", weight: 157.25),
        Element(named: "Terbium", symbol: "Tb", weight: 158.9253),
        Element(named: "Dysprosium", symbol: "Dy", weight: 162.5),
        Element(named: "Holmium", symbol: "Ho", weight: 164.9303),
        Element(named: "Erbium", symbol: "Er", weight: 167.259),
        Element(named: "Thulium", symbol: "Tm", weight: 168.9342),
        Element(named: "Ytterbium", symbol: "Yb", weight: 173.04),
        Element(named: "Lutetium", symbol: "Lu", weight: 174.967),
        Element(named: "Hafnium", symbol: "Hf", weight: 178.49),
        Element(named: "Tantalum", symbol: "Ta", weight: 180.9479),
        Element(named: "Tungsten", symbol: "W", weight: 183.84),
        Element(named: "Rhenium", symbol: "Re", weight: 186.207),
        Element(named: "Osmium", symbol: "Os", weight: 190.23),
        Element(named: "Iridium", symbol: "Ir", weight: 192.217),
        Element(named: "Platinum", symbol: "Pt", weight: 195.078),
        Element(named: "Gold", symbol: "Au", weight: 196.9665),
        Element(named: "Mercury", symbol: "Hg", weight: 200.59),
        Element(named: "Thallium", symbol: "Tl", weight: 204.3833),
        Element(named: "Lead", symbol: "Pb", weight: 207.2),
        Element(named: "Bismuth", symbol: "Bi", weight: 208.9804),
        Element(named: "Polonium", symbol: "Po", weight: 209.0),
        Element(named: "Astatine", symbol: "At", weight: 210.0),
        Element(named: "Radon", symbol: "Rn", weight: 222.0),
        Element(named: "Francium", symbol: "Fr", weight: 223.0),
        Element(named: "Radium", symbol: "Ra", weight: 226.0),
        Element(named: "Actinium", symbol: "Ac", weight: 227.0),
        Element(named: "Thorium", symbol: "Th", weight: 232.0381),
        Element(named: "Protactinium", symbol: "Pa", weight: 231.0359),
        Element(named: "Uranium", symbol: "U", weight: 238.0289),
        Element(named: "Neptunium", symbol: "Np", weight: 237.0),
        Element(named: "Plutonium", symbol: "Pu", weight: 244.0),
        Element(named: "Americium", symbol: "Am", weight: 243.0),
        Element(named: "Curium", symbol: "Cm", weight: 247.0),
        Element(named: "Berkelium", symbol: "Bk", weight: 247.0),
        Element(named: "Californium", symbol: "Cf", weight: 251.0),
        Element(named: "Einsteinium", symbol: "Es", weight: 252.0),
        Element(named: "Fermium", symbol: "Fm", weight: 257.0),
        Element(named: "Mendelevium", symbol: "Md", weight: 258.0),
        Element(named: "Nobelium", symbol: "No", weight: 259.0),
        Element(named: "Lawrencium", symbol: "Lr", weight: 262.0),
        Element(named: "Rutherfordium", symbol: "Rf", weight: 261.0),
        Element(named: "Dubnium", symbol: "Db", weight: 262.0),
        Element(named: "Seaborgium", symbol: "Sg", weight: 266.0),
        Element(named: "Bohrium", symbol: "Bh", weight: 264.0),
        Element(named: "Hassium", symbol: "Hs", weight: 277.0),
        Element(named: "Meitnerium", symbol: "Mt", weight: 268.0)
    ]
    
    public static func with(symbol: String?) -> Element? {
        guard let symbol = symbol else { return nil }
        return Element.all.first(where: { $0.symbol == symbol })
    }
    
    
    //MARK: - Properties
    
    let name: String
    let symbol: String
    let weight: Double
    
    private init(named name: String, symbol: String, weight: Double) {
        self.name = name
        self.symbol = symbol
        self.weight = weight
    }
    
    
    //MARK: - Hashable and Printable
    
    var description: String {
        return self.name
    }
    
    var hashValue: Int {
        return self.name.hashValue
    }
    
    static func ==(left: Element, right: Element) -> Bool {
        return left.name == right.name
    }
    
    
}
