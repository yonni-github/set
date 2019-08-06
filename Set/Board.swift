//
//  Board.swift
//  Set
//
//  Created by Yonas on 3/9/18.
//  Copyright © 2018 SJSU. All rights reserved.
//

import UIKit

class Board: UIView {

    var grid = Grid2()
    var cardViews = [SetCardView]() { didSet { layoutSubviews() }}
    
    override func awakeFromNib() {
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture))
        self.addGestureRecognizer(rotateGesture)
    }
  
    override func layoutSubviews() {
        self.backgroundColor = UIColor.clear
        grid.cellCount = CGFloat(cardViews.count)
        grid.frame = bounds
        
       // remove all subviews
        for subView in subviews {
            subView.removeFromSuperview()
        }
        
        for cardViewIndex in cardViews.indices {
            let cardView = cardViews[cardViewIndex]
           
            cardView.frame = CGRect(origin: grid.cells[cardViewIndex].origin, size: grid.cellSize!)
            addSubview(cardViews[cardViewIndex])
        }
     
    }
  
    @objc func handleRotateGesture(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .began: break
        case .changed: shuffle()
        case .ended: break
        default: break
        }
    }
    //shuffle cards on board/table
    func shuffle(){
        var newCardViews = [SetCardView]()
        while 0 < cardViews.count {
            let randomIndex = Int(arc4random_uniform(UInt32(cardViews.count)))
            newCardViews.append(cardViews.remove(at: randomIndex))
        }
        cardViews = newCardViews
        layoutSubviews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
}
