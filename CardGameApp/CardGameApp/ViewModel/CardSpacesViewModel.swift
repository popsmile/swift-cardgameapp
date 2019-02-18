//
//  CardSpacesViewModel.swift
//  CardGameApp
//
//  Created by 윤지영 on 17/02/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import Foundation

class CardSpacesViewModel {
    private let count = 4
    private var cardSpaceViewModels: [CardSpaceViewModel]

    required init() {
        cardSpaceViewModels = []
        setCardSpaceViewModels()
    }

    private func setCardSpaceViewModels() {
        for _ in 0..<count {
            cardSpaceViewModels.append(CardSpaceViewModel())
        }
    }

    func push(_ cardViewModel: CardViewModel, at index: Int) {
        guard cardSpaceViewModels.indices.contains(index) else { return }
        cardSpaceViewModels[index].push(cardViewModel)
    }

    func canPush(_ cardViewModel: CardViewModel) -> Int? {
        for (index, cardSpace) in cardSpaceViewModels.enumerated() {
            if cardSpace.canPush(cardViewModel) { return index }
        }
        return nil
    }

}
