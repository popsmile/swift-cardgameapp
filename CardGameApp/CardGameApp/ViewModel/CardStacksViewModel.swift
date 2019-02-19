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

    func canPush(_ cardViewModel: CardViewModel) -> Int? {
        for (index, cardStack) in cardStackViewModels.enumerated() {
            if cardStack.canPush(cardViewModel) { return index }
        }
        return nil
    }

    func push(_ cardViewModel: CardViewModel, at indexOfCardStack: Int) {
        guard cardStackViewModels.indices.contains(indexOfCardStack) else { return }
        cardStackViewModels[indexOfCardStack].push(cardViewModel)
    }

    func pop(from indexPath: IndexPath, toTheEnd: Bool = true) -> [CardViewModel]? {
        guard cardStackViewModels.indices.contains(indexPath.section) else { return nil }
        return cardStackViewModels[indexPath.section].pop(from: indexPath.item, toTheEnd: toTheEnd)
    }

    func moveCardViewModel(at indexPath: IndexPath) -> Int? {
        guard cardStackViewModels.indices.contains(indexPath.section) else { return nil }
        let cardStackViewModel = cardStackViewModels[indexPath.section]
        let location = cardStackViewModel.accessCardViewModel(at: indexPath.item) {
            [unowned self] cardViewModel in self.canPush(cardViewModel)
        }
        if let location = location {
            let cardViewModels = cardStackViewModel.pop(from: indexPath.item)
            cardViewModels?.reversed().forEach { cardStackViewModels[location].push($0) }
            return location
        }
        return nil
    }

}

/* MARK: Access to inner properties by closure */
extension CardStacksViewModel {

    func iterateCardStackViewModels(_ deliver: (CardStackViewModel) -> Void) {
        for cardStackViewModel in cardStackViewModels {
            deliver(cardStackViewModel)
        }
    }

    func accessCardViewModel(at indexPath: IndexPath, _ deliver: (CardViewModel) -> Int?) -> Int? {
        guard cardStackViewModels.indices.contains(indexPath.section) else { return nil }
        return cardStackViewModels[indexPath.section].accessCardViewModel(at: indexPath.item, by: deliver)
    }

}
