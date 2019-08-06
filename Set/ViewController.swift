//
//  ViewController.swift
//  Set Game
//
//  Created by Yonas on 2/11/18.
//  Copyright © 2018 SJSU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = SetGame()
    private lazy var cardViewAndCardPairs = [SetCardView: Card]()

    var scoreCount = 0 {
        didSet {
            displayScore.text = "Score: \(scoreCount)"
        }
    }
    var cardsDealt = 0 {
        didSet {
            if game.deck.count == 0{
                dealButton.isEnabled = false
            } else {
                dealButton.isEnabled = true
            }
        }
    }
    var setFound = false {
        didSet {
            if setFound{
            setFoudLabel.isHidden = false
            } else {
                setFoudLabel.isHidden = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        game = SetGame()
        game.dealCards(count: 12)
        updateViewFromModel()
        dealButton.isEnabled = true
        
       let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture))
       rotateGesture.rotation = 1
        board.addGestureRecognizer(rotateGesture)
    }
    
    @IBOutlet weak var board: Board!
    
    @IBAction func rotate(_ sender: UIRotationGestureRecognizer) {
        print("rotated")
        switch sender.state {
        case .began: break
        case .changed: board.shuffle()
        case .ended: break
        default: break
        }
    }
    //Deal three cards by swiping right
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        game.dealCards(count: 3)
        updateViewFromModel()
    }
    @IBOutlet weak var setFoudLabel: UILabel!
    @IBOutlet weak var displayScore: UILabel!
    @IBOutlet weak var dealButton: UIButton!
    
    @IBAction func dealCards(_ sender: UIButton) {
            game.dealCards(count: 3)
            updateViewFromModel()
    }
   
    
    @IBAction func newGameButton(_ sender: UIButton) {
        game = SetGame()
        game.dealCards(count: 12)
        updateViewFromModel()
        dealButton.isEnabled = true
    }
    
    @objc func handleRotationGesture(_ sender: UIRotationGestureRecognizer) {
        print("rotated")
        switch sender.state {
        case .began: break
        case .changed: board.shuffle()
        case .ended: break
        default: break
        }
    }
    
    //create a card view from a card
    func makeCardView(fromCard card: Card) -> SetCardView {
        let cardView = SetCardView()
        
        switch card.shape {
        case .squiggle: cardView.shape = .squiggle
        case .oval: cardView.shape = .oval
        case .diamond: cardView.shape = .diamond
        }
        
        switch card.shade {
        case .empty: cardView.shade = .empty
        case .solid: cardView.shade = .solid
        case .stripe: cardView.shade = .striped
        }
        
        cardView.count = card.number.rawValue
        cardView.selected = card.isSelected
        cardView.misMatched = card.isMismatched
        
        switch card.color {
        case .red: cardView.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .blue: cardView.color = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case .green: cardView.color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        return cardView
    }
    
    //handle tap gesture on a card view
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let cardView = sender.view as! SetCardView

        let card = cardViewAndCardPairs[cardView]
        var cardIndex: Int? {
            for index in self.game.cardsOnTable.indices {
                if card == self.game.cardsOnTable[index]{
                    return index
                }
            }
            return nil
        }
        
        game.selectCard(at: cardIndex!)
        updateViewFromModel()
    }
    
    //update UI elements
    private func updateViewFromModel() {
        scoreCount = game.score
        cardsDealt = game.cardsDealt
        setFound = game.setFound
        var aCardView = SetCardView()
       
        board.cardViews.removeAll()
        for index in game.cardsOnTable.indices {
            aCardView = makeCardView(fromCard: game.cardsOnTable[index])
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            aCardView.addGestureRecognizer(tap)
            cardViewAndCardPairs[aCardView] = game.cardsOnTable[index]
            board.cardViews.append(aCardView)
        }
    }
    
}

