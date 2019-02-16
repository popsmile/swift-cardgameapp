//
//  CardSpacesViewModel.swift
//  CardGameApp
//
//  Created by 윤지영 on 17/02/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import Foundation

class CardSpacesViewModel {
    private var cardSpaceViewModels: [CardSpaceViewModel]

    required init() {
        self.cardSpaceViewModels = Array(repeating: CardSpaceViewModel(), count: 4)
    }

    func push(cardViewModel card: CardViewModel) -> Bool {
        for cardSpace in cardSpaceViewModels {
            if cardSpace.push(cardViewModel: card) { return true }
        }
        return false
    }

}
