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

    func push(cardViewModel: CardViewModel) {
        cardViewModels.append(cardViewModel)
    }

    func canPush(cardViewModel card: CardViewModel) -> Bool {
        if cardViewModels.isEmpty && card.isLowest { return true }
        guard let lastCard = cardViewModels.last else { return false }
        guard card.hasSameSuit(with: lastCard) else { return false }
        if card.isNextHigher(than: lastCard) { return true }
        return false
    }

}
