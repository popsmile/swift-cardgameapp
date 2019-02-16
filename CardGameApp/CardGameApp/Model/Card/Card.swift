//
//  File.swift
//  CardGame
//
//  Created by 윤지영 on 13/11/2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

class Card: CustomStringConvertible {
    private let suit: Suit
    private let rank: Rank

    init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
    }

    var description: String {
        return "\(suit.firstLetter)\(rank.value)"
    }

    var isLowest: Bool {
        return rank == .A
    }

    func hasSameSuit(with card: Card) -> Bool {
        return self.suit == card.suit
    }

    func hasSameColor(with card: Card) -> Bool {
        return self.suit.hasSameColor(with: card.suit)
    }

    func isNextHigher(than card: Card) -> Bool {
        guard let next = card.rank.next else { return false }
        return self.rank == next
    }

    func isNextLower(than card: Card) -> Bool {
        guard let next = self.rank.next else { return false }
        return next == card.rank
    }

}

extension Card: Comparable {

    static func < (lhs: Card, rhs: Card) -> Bool {
        if lhs.rank == rhs.rank {
            return lhs.suit.rawValue < rhs.suit.rawValue
        }
        if lhs.suit == rhs.suit {
            return lhs.rank.rawValue < rhs.rank.rawValue
        }
        return lhs.rank.rawValue < rhs.rank.rawValue
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }

}
