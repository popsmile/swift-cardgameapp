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

    func moveCardViewModelsToCardDeckViewModel() {
        while !cardPileViewModel.isEmpty {
            guard let cardViewModel = cardPileViewModel.pop() else { return }
            cardViewModel.flip()
            cardDeckViewModel.push(cardViewModel)
        }
    }

    /* Double Tap */
    func moveCardFromStackToSpace(cardAt indexPath: IndexPath) -> Int? {
        let space = cardStacksViewModel.accessCardViewModel(at: indexPath) {
            [unowned self] cardViewModel in self.cardSpacesViewModel.canPush(cardViewModel)
        }
        if let location = space {
            let cardViewModels = cardStacksViewModel.pop(from: indexPath, toTheEnd: false)
            cardViewModels?.forEach { cardSpacesViewModel.push($0, at: location)}
            return location
        }
        return nil
    }

    func moveCardFromStackToStack(cardAt indexPath: IndexPath) -> Int? {
        return cardStacksViewModel.moveCardViewModel(at: indexPath)
    }

    func moveCardFromPileToSpace() -> Int? {
        let space = cardPileViewModel.accessCardViewModel {
            [unowned self] cardViewModel in self.cardSpacesViewModel.canPush(cardViewModel)
        }
        if let location = space {
            guard let cardViewModel = cardPileViewModel.pop() else { return nil }
            cardSpacesViewModel.push(cardViewModel, at: location)
            return location
        }
        return nil
    }

    func moveCardFromPileToStack() -> Int? {
        let stack = cardPileViewModel.accessCardViewModel {
            [unowned self] cardViewModel in self.cardStacksViewModel.canPush(cardViewModel)
        }
        if let location = stack {
            guard let cardViewModel = cardPileViewModel.pop() else { return nil }
            cardStacksViewModel.push(cardViewModel, at: location)
            return location
        }
        return nil
    }

}
