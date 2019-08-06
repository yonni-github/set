//
//  Set.swift
//  Set
//
//  Created by Yonas on 2/16/18.
//  Copyright © 2018 SJSU. All rights reserved.
//

import Foundation

class SetGame {
    private(set) var deck = [Card]()
    private(set) var cardsOnTable = [Card]()
    var numberOfSelectedCards = 0
    var score = 0
    var cardsDealt = 0
    var setFound = false
    
    func selectCard(at index: Int){
        
        for index in cardsOnTable.indices {
            cardsOnTable[index].isMismatched = false
        }
        if !cardsOnTable[index].isSelected {
            cardsOnTable[index].isSelected = true
            numberOfSelectedCards += 1
        } else {
            cardsOnTable[index].isSelected = false
            numberOfSelectedCards -= 1
            score -= 1
        }
        setFound = false
        if numberOfSelectedCards == 3 {
            var indicesOfSelectedCards = [Int]()
            for index in cardsOnTable.indices {
                if cardsOnTable[index].isSelected {
                    indicesOfSelectedCards.append(index)
                }
            }
            setFound = isSet(arrayOfIdices: indicesOfSelectedCards)
            if setFound {
                score += 3
                cardsDealt -= 3
                removeCardsFromTable(arrayOfIdices: indicesOfSelectedCards)
                dealCards(count: 3)
            } else {
                for index in indicesOfSelectedCards.indices {
                    cardsOnTable[indicesOfSelectedCards[index]].isMismatched = true
                }
                score -= 4
            }
            
            for index in cardsOnTable.indices {
                cardsOnTable[index].isSelected = false
            }
            numberOfSelectedCards = 0
        }
    }
     // check if the selected cards form a set
    func isSet(arrayOfIdices: Array<Int>) -> Bool{
        let firstCard = cardsOnTable[arrayOfIdices[0]]
        let secondCard = cardsOnTable[arrayOfIdices[1]]
        let thirdCard = cardsOnTable[arrayOfIdices[2]]
        
        var sum = 0
        sum += countSimilar(item1: firstCard.number.rawValue, item2: secondCard.number.rawValue, item3: thirdCard.number.rawValue)
        sum += countSimilar(item1: firstCard.color.rawValue, item2: secondCard.color.rawValue, item3: thirdCard.color.rawValue)
        sum += countSimilar(item1: Int(firstCard.shade.rawValue), item2: Int(secondCard.shade.rawValue), item3: Int(thirdCard.shade.rawValue))
        sum += countSimilar(item1: firstCard.shape.rawValue, item2: secondCard.shape.rawValue, item3: thirdCard.shape.rawValue)
        
        if (sum == 3 || sum == 9){
            return true
        }
        
        return false
    }
    
    private func countSimilar( item1: Int, item2: Int, item3: Int)-> Int {
        if (item1 == item2 && item2 == item3){
            return 3
        } else if (item1 == item2 || item2 == item3 || item1 == item3){
            return 2
        }
        return 0
    }
    
    //remove matched cards (a set) from table
    func removeCardsFromTable(arrayOfIdices: Array<Int>) {
        let arrayOfIdicesCopy = arrayOfIdices.reversed()

        for index in arrayOfIdicesCopy.indices {
            cardsOnTable.remove(at: arrayOfIdicesCopy[index])
        }
    }
    //deal cards of requested quantity
    func dealCards(count: Int){
        var numberOfCardsToDeal = count
        var index = 0
        while numberOfCardsToDeal > 0 && index < deck.count{
            if !deck[index].isDealt {
                deck[index].isDealt = true
                cardsOnTable.append(deck.remove(at: index))
                numberOfCardsToDeal -= 1
                cardsDealt += 1
            }
            index += 1
        }
    }
    
    //Create deck of cards
    init (){
        for number in 1...3 {
            for shape in 1...3 {
                for color in 1...3 {
                    for shade in 1...3 {
                        let card = Card(with: number, shape, color, shade)
                        deck.append(card)
                    }
                }
            }
            shuffle()
        }
    }
    
    //shuffle the deck of cards
    private func shuffle(){
        var newdeck = [Card]()
        while 0 < deck.count {
            let randomIndex = Int(arc4random_uniform(UInt32(deck.count)))
            newdeck.append(deck.remove(at: randomIndex))
        }
        deck = newdeck
    }
}

