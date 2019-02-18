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
    var cardSpacesViewModel: CardSpacesViewModel

    init() {
        cardGame = CardGame()
        cardStacksViewModel = CardStacksViewModel(cardStacks: cardGame.cardStacks)
        cardDeckViewModel = CardDeckViewModel(cardDeck: cardGame.cardDeck)
        cardPileViewModel = CardPileViewModel()
        cardSpacesViewModel = CardSpacesViewModel()
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

    /* Double Tap */
    func moveToSpace(indexOfCard: Int, indexOfCardStack: Int) -> Int? {
        let space = cardStacksViewModel.accessCardViewModel(at: indexOfCard, of: indexOfCardStack) {
            [unowned self] cardViewModel in self.cardSpacesViewModel.canPush(cardViewModel: cardViewModel)
        }
        if let location = space {
            let cardViewModels = cardStacksViewModel.removeCardViewModels(from: indexOfCard, of: indexOfCardStack, toTheEnd: false)
            cardViewModels?.forEach { cardSpacesViewModel.push(cardViewModel: $0, at: location) }
            return location
        }
        return nil
    }

    func moveToStack(indexOfCard: Int, indexOfCardStack: Int) -> Int? {
        return cardStacksViewModel.moveCardViewModel(at: indexOfCard, of: indexOfCardStack)
    }

    /* Shake Motion */
    func reset() {
        cardGame.reset()
        cardStacksViewModel.replace(cardStacks: cardGame.cardStacks)
        moveCardViewModelsToCardDeckViewModel()
        cardDeckViewModel.replace(cardDeck: cardGame.cardDeck)
    }

    private func moveCardViewModelsToCardDeckViewModel() {
        while !cardPileViewModel.isEmpty {
            guard let cardViewModel = cardPileViewModel.pop() else { return }
            cardViewModel.flip()
            cardDeckViewModel.push(cardViewModel)
        }
    }

}
