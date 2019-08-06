//
//  Grid2.swift
//  Set
// **********************************************
//  Grid2.swift is an improved version of Grid.swift
// Grid2 makes better utilization of the board's surface area
//  by using a different method of getting optimal cell numbers
// of grid for a given number of cards and
//  calculating cell dimensions thereafter
//  Created by Yonas on 3/14/18.
//  Copyright © 2018 SJSU. All rights reserved.
//


import Foundation
import UIKit

struct  Grid2 {
    var cellCount: CGFloat?
    var rowCount = 0
    var colCount = 0
    var cells: [Cell]
    var cellArea: CGFloat?
    var cellWidth = 0
    var cellHeight = 0
    var cellSize: CGSize?
    var frame: CGRect? {
        didSet{
            calculate()
        }
    }
    
    struct Cell {
        var origin: CGPoint
    }
    init(){
        cellCount = 0.0
        colCount = 0
        rowCount = 0
        cellWidth = 0
        cellHeight = 0
        cellArea = CGFloat()
        cells = [Cell]()
    }
    
    mutating func calculate(){
        if cellCount != 0 {
            calculateRowAndColCount()
            calculateCellSize()
            createCells()
        }
    }
    mutating func calculateCellSize(){
        
        //adjust width and height of cell
        cellWidth = Int((frame?.width)! / CGFloat(colCount))
        cellHeight = Int((frame?.height)! / CGFloat(rowCount))
    
        if Double(cellWidth) > Double(cellHeight) * 1.25 {
            cellWidth = Int(Double(cellWidth) * 0.75)
        }
       
        cellSize = CGSize(width: cellWidth, height: cellHeight)
    }
    mutating func calculateRowAndColCount(){
        for number in 1...Int(cellCount!) {
            if number * number >= Int(cellCount!){
                rowCount = number
                colCount = number
                return
            }else if number * (number + 1) >= Int(cellCount!){
                if Int((frame?.width)!) > Int((frame?.height)!) {
                    rowCount = number
                    colCount = number + 1
                }else if Int((frame?.width)!) <= Int((frame?.height)!) {
                    rowCount = number + 1
                    colCount = number
                }
                return
            }
        }
    }
    
    //cell is indicated by left upper corner point (origin)
    mutating func createCells(){
        cells.removeAll()
        if rowCount < colCount {
            for x in 0..<colCount{
                for y in 0..<rowCount{
                    var cell = Cell(origin: CGPoint(x: 0,y: 0))
                    cell.origin = CGPoint(x: x*cellWidth, y: y*cellHeight)
                    cells.append(cell)
                }
            }
        } else {
            for y in 0..<rowCount{
                for x in 0..<colCount{
                    var cell = Cell(origin: CGPoint(x: 0,y: 0))
                    cell.origin = CGPoint(x: x*cellWidth, y: y*cellHeight)
                    cells.append(cell)
                }
            }
        }
    }
}

