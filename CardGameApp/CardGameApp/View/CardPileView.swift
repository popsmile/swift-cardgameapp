//
//  CardPileView.swift
//  CardGameApp
//
//  Created by 윤지영 on 04/02/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class CardPileView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    private func addDoubleTapGestureRecognizer(to cardView: CardView) {
        let doubleTapGestureRecognizer = DoubleTapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        cardView.addGestureRecognizer(doubleTapGestureRecognizer)
    }

    private func removeDoubleTapGestureRecognizer(from cardView: CardView) {
        guard let doubleTapGestureRecognizer = cardView.gestureRecognizers?.first else { return }
        cardView.removeGestureRecognizer(doubleTapGestureRecognizer)
    }

    @objc private func handleDoubleTap() {
        NotificationCenter.default.post(name: .cardPileDidDoubleTapped, object: self)
    }

    func push(_ cardView: CardView) {
        addDoubleTapGestureRecognizer(to: cardView)
        addSubview(cardView)
    }

    func pop() -> CardView? {
        guard let cardView = subviews.last as? CardView else { return nil }
        cardView.removeFromSuperview()
        removeDoubleTapGestureRecognizer(from: cardView)
        return cardView
    }

}

extension Notification.Name {
    static let cardPileDidDoubleTapped = NSNotification.Name("cardPileDidDoubleTapped")
}
