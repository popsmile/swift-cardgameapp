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

}
