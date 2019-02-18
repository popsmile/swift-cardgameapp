//
//  CardSpacesView.swift
//  CardGameApp
//
//  Created by 윤지영 on 10/02/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class CardSpacesView: UIStackView {

    required init(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    convenience init(frame: CGRect, spaces: Int) {
        self.init(frame: frame)
        createCardSpaceViews(spaces: spaces)
    }

    private func configureLayout() {
        spacing = 5
        distribution = .fillEqually
    }

    private func createCardSpaceViews(spaces: Int) {
        for _ in 0..<spaces {
            let cardSpaceView = CardSpaceView(frame: .zero)
            cardSpaceView.frame.size = CardViewLayout.size
            addArrangedSubview(cardSpaceView)
        }
    }

    func push(_ cardView: CardView, at indexOfSpace: Int) {
        guard subviews.indices.contains(indexOfSpace) else { return }
        guard let cardSpaceView = subviews[indexOfSpace] as? CardSpaceView else { return }
        cardSpaceView.push(cardView)
    }

    func popAll() -> [CardView]? {
        var cardViews = [CardView]()
        for view in subviews {
            guard let cardSpaceView = view as? CardSpaceView else { continue }
            guard let cardViewsRemoved = cardSpaceView.popAll() else { continue }
            cardViewsRemoved.forEach { cardViews.append($0) }
        }
        return cardViews.isEmpty ? nil : cardViews
    }

}
