//
//  card.swift
//  Set
//
//  Created by Yonas on 2/11/18.
//  Copyright © 2018 SJSU. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    var isSelected = false
    var isMatched = false
    var isMismatched = false
    var isDealt = false
    var id: Int
    
    var number: Number
    var color: Color
    var shape: Shape
    var shade: Shade
    
    static var nextUid = 1
    static func generateUid() -> Int {
        nextUid += 1
        return nextUid
    }
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(with num: Int, _ col: Int, _ shp: Int, _ shd: Int) {
        self.number = Number(rawValue: num)!
        self.color = Color(rawValue: col)!
        self.shape = Shape(rawValue: shp)!
        self.shade = Shade(rawValue: shd)!
        self.id = Card.generateUid()
    }
    
    enum Number: Int {
        case one = 1
        case two
        case three
        
       var description: Int {
            switch self {
            case .one: return 1
            case .two: return 2
            case .three: return 3
            }
        }
    }
    
    enum Color: Int, CustomStringConvertible {
        case red = 1
        case green
        case blue
        
        var description: String {
            switch self {
            case .red: return "red"
            case .green: return "green"
            case .blue: return "blue"
            }
        }
    }
    
    enum Shape: Int, CustomStringConvertible {
        case oval = 1
        case diamond
        case squiggle
        
        var description: String {
            switch self {
            case .oval: return "oval"
            case .diamond: return "diamond"
            case .squiggle: return "squiggle"
            }
        }
    }
    
    enum Shade: Int, CustomStringConvertible {
        case solid = 1
        case stripe
        case empty
        
        var description: String {
            switch self {
            case .solid: return "solid"
            case .stripe: return "stripe"
            case .empty: return "empty"
            }
        }
    }
    
}
