//
//  CardStacksViewModel.swift
//  CardGameApp
//
//  Created by 윤지영 on 31/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import Foundation

class CardStacksViewModel {
    private var cardStacks: CardStacks
    private var cardStackViewModels: [CardStackViewModel]

    required init(cardStacks: CardStacks) {
        self.cardStacks = cardStacks
        self.cardStackViewModels = []
        makeCardStackViewModels()
    }

    private func makeCardStackViewModels() {
        cardStacks.iterateCardStack { [unowned self] cardStack in
            let cardStackViewModel = CardStackViewModel(cardStack: cardStack)
            self.cardStackViewModels.append(cardStackViewModel)
        }
    }

    func replace(cardStacks: CardStacks) {
        self.cardStacks = cardStacks
        replaceCardStackViewModels()
    }

    private func replaceCardStackViewModels() {
        for index in cardStackViewModels.indices {
            cardStacks.accessCardStack(at: index) { [unowned self] cardStack in
                self.cardStackViewModels[index].replace(cardStack: cardStack)
            }
        }
    }

}

extension CardStacksViewModel {

    func iterateCardStackViewModels(_ deliver: (CardStackViewModel) -> Void) {
        for cardStackViewModel in cardStackViewModels {
            deliver(cardStackViewModel)
        }
    }

    func accessCardViewModel(at indexOfCard: Int, of indexOfCardStack: Int, _ deliver: (CardViewModel) -> Int?) -> Int? {
        guard cardStackViewModels.indices.contains(indexOfCardStack) else { return nil }
        return cardStackViewModels[indexOfCardStack].accessCardViewModel(at: indexOfCard, by: deliver)
    }

    func removeCardViewModels(from indexOfCard: Int, of indexOfcardStack: Int, toTheEnd: Bool = true) -> [CardViewModel]? {
        guard cardStackViewModels.indices.contains(indexOfcardStack) else { return nil }
        return cardStackViewModels[indexOfcardStack].removeCardViewModels(from: indexOfCard, toTheEnd: toTheEnd)
    }

    private func canPush(cardViewModel card: CardViewModel) -> Int? {
        for (index, cardStack) in cardStackViewModels.enumerated() {
            if cardStack.canPush(cardViewModel: card) { return index }
        }
        return nil
    }

    func moveCardViewModel(at indexOfCard: Int, of indexOfCardStack: Int) -> Int? {
        guard cardStackViewModels.indices.contains(indexOfCardStack) else { return nil }
        let cardStack = cardStackViewModels[indexOfCardStack]
        let location = cardStack.accessCardViewModel(at: indexOfCard) {
            [unowned self] cardViewModel in self.canPush(cardViewModel: cardViewModel)
        }
        if let location = location {
            let cardViewModels = cardStack.removeCardViewModels(from: indexOfCard)
            cardViewModels?.forEach { cardStackViewModels[location].push(cardViewModel: $0) }
            return location
        }
        return nil
    }

}
