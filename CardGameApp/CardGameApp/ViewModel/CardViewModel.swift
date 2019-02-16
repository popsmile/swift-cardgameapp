//
//  CardViewModel.swift
//  CardGameApp
//
//  Created by 윤지영 on 29/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import Foundation

class CardViewModel {
    private var card: Card
    private var opened: Bool

    required init(card: Card) {
        self.card = card
        self.opened = false
    }

    var imageName: String {
        return opened ? "\(card)" : "card-back"
    }

    func flip() {
        opened.toggle()
        let userInfo = [Notification.InfoKey.imageNameOfCard: imageName]
        NotificationCenter.default.post(name: .cardDidFlip, object: self, userInfo: userInfo)
    }

    func replace(card: Card) {
        self.card = card
        let userInfo = [Notification.InfoKey.imageNameOfCard: imageName]
        NotificationCenter.default.post(name: .cardDidReset, object: self, userInfo: userInfo)
    }

    var isLowest: Bool {
        return card.isLowest
    }

    func hasSameColor(with cardViewModel: CardViewModel) -> Bool {
        return card.hasSameColor(with: cardViewModel.card)
    }

    func isNextHigher(than cardViewModel: CardViewModel) -> Bool {
        return card.isNextHigher(than: cardViewModel.card)
    }

    func isNextLower(than cardViewModel: CardViewModel) -> Bool {
        return card.isNextLower(than: cardViewModel.card)
    }

}

extension NSNotification.Name {
    static let cardDidFlip = NSNotification.Name("cardDidFlip")
    static let cardDidReset = NSNotification.Name("cardDidReset")
}

extension Notification {
    struct InfoKey {
        static let imageNameOfCard = "imageNameOfCard"
    }
}
