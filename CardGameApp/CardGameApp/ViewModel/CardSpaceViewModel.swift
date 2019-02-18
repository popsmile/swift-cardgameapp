//
//  CardSpaceViewModel.swift
//  CardGameApp
//
//  Created by 윤지영 on 17/02/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import Foundation

class CardSpaceViewModel {
    private var cardViewModels: [CardViewModel]

    init() {
        self.cardViewModels = []
    }

    func push(_ cardViewModel: CardViewModel) {
        cardViewModels.append(cardViewModel)
    }

    func canPush(_ cardViewModel: CardViewModel) -> Bool {
        if cardViewModels.isEmpty && cardViewModel.isLowest { return true }
        guard let lastCard = cardViewModels.last else { return false }
        guard cardViewModel.hasSameSuit(with: lastCard) else { return false }
        if cardViewModel.isNextHigher(than: lastCard) { return true }
        return false
    }

    private func pop() -> CardViewModel? {
        if cardViewModels.isEmpty { return nil }
        return cardViewModels.removeLast()
    }

    func popAll() -> [CardViewModel]? {
        if cardViewModels.isEmpty { return nil }
        var cardViewModelsRemoved = [CardViewModel]()
        while !cardViewModels.isEmpty {
            guard let cardViewModel = pop() else { continue }
            cardViewModelsRemoved.append(cardViewModel)
        }
        return cardViewModelsRemoved
    }

}
