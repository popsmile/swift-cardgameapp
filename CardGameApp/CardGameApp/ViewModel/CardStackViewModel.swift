//
//  CardStackViewModel.swift
//  CardGameApp
//
//  Created by 윤지영 on 29/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import Foundation

class CardStackViewModel {
    private var cardStack: CardStack
    private var cardViewModels: [CardViewModel]

    init(cardStack: CardStack) {
        self.cardStack = cardStack
        self.cardViewModels = []
        makeCardViewModels()
        flipLastCard()
    }

    private func makeCardViewModels() {
        cardStack.iterateCards { [unowned self] card in
            let cardViewModel = CardViewModel(card: card)
            self.cardViewModels.append(cardViewModel)
        }
    }

    private func flipLastCard() {
        if let lastCardViewModel = cardViewModels.last {
            lastCardViewModel.open()
        }
    }

    func canPush(_ cardViewModel: CardViewModel) -> Bool {
        if cardViewModels.isEmpty && cardViewModel.isHighest { return true }
        guard let lastCard = cardViewModels.last else { return false }
        if cardViewModel.hasSameColor(with: lastCard) { return false }
        if cardViewModel.isNextLower(than: lastCard) { return true }
        return false
    }

    func push(_ cardViewModel: CardViewModel) {
        cardViewModels.append(cardViewModel)
    }

    func pop(from index: Int, toTheEnd: Bool = true) -> [CardViewModel]? {
        guard cardViewModels.indices.contains(index) else { return nil }
        let lastIndex = toTheEnd ? cardViewModels.count : index + 1
        var removed = [CardViewModel]()
        for _ in index..<lastIndex {
            removed.append(cardViewModels.removeLast())
        }
        flipLastCard()
        return removed
    }

}

/* MARK: Access to inner properties by closure */
extension CardStackViewModel {

    func iterateCardViewModels(_ deliver: (CardViewModel) -> Void) {
        for cardViewModel in cardViewModels {
            deliver(cardViewModel)
        }
    }

    func accessCardViewModel(at index: Int, by deliver: (CardViewModel) -> Int?) -> Int? {
        guard cardViewModels.indices.contains(index) else { return nil }
        guard cardViewModels[index].opened else { return nil }
        return deliver(cardViewModels[index])
    }

}
