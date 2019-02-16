//
//  CardGameViewModel.swift
//  CardGameApp
//
//  Created by 윤지영 on 04/02/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import Foundation

class CardGameViewModel {
    private var cardGame: CardGame
    
    var cardStacksViewModel: CardStacksViewModel
    var cardDeckViewModel: CardDeckViewModel
    var cardPileViewModel: CardPileViewModel

    init() {
        cardGame = CardGame()
        cardStacksViewModel = CardStacksViewModel(cardStacks: cardGame.cardStacks)
        cardDeckViewModel = CardDeckViewModel(cardDeck: cardGame.cardDeck)
        cardPileViewModel = CardPileViewModel()
    }

    private func moveCardViewModelsToCardDeckViewModel() {
        while !cardPileViewModel.isEmpty {
            guard let cardViewModel = cardPileViewModel.pop() else { return }
            cardViewModel.flip()
            cardDeckViewModel.push(cardViewModel)
        }
    }

}

/* MARK: User interaction events */
extension CardGameViewModel {

    /* Tap */
    func openCardFromCardDeck() {
        guard let cardViewModel = cardDeckViewModel.pop() else { return }
        cardViewModel.flip()
        cardPileViewModel.push(cardViewModel)
    }

    /* Shake Motion */
    func reset() {
        cardGame.reset()
        cardStacksViewModel.replace(cardStacks: cardGame.cardStacks)
        moveCardViewModelsToCardDeckViewModel()
        cardDeckViewModel.replace(cardDeck: cardGame.cardDeck)
    }

}
