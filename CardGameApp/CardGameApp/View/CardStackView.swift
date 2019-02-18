//
//  CardStackView.swift
//  CardGameApp
//
//  Created by 윤지영 on 28/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class CardStackView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect, viewModel: CardStackViewModel) {
        self.init(frame: frame)
        createCardViews(with: viewModel)
        if let cardViews = subviews as? [CardView] {
            cardViews.forEach { addDoubleTapGestureRecognizer(to: $0) }
        }
    }

    private func createCardViews(with viewModel: CardStackViewModel) {
        viewModel.iterateCardViewModels { [unowned self] cardViewModel in
            var frame = CGRect(origin: .zero, size: CardViewLayout.size)
            if let lastCardView = subviews.last {
                frame.origin.y = lastCardView.frame.origin.y + 20
            }
            let cardView = CardView(frame: frame, viewModel: cardViewModel)
            self.addSubview(cardView)
        }
    }

    private func addDoubleTapGestureRecognizer(to cardView: CardView) {
        let doubleTapGestureRecognizer = DoubleTapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(sender:)))
        cardView.addGestureRecognizer(doubleTapGestureRecognizer)
    }

    private func removeDoubleTapGestureRecognizer(from cardView: CardView) {
        guard let douebleTapGestureRecognizer = cardView.gestureRecognizers?.first else { return }
        cardView.removeGestureRecognizer(douebleTapGestureRecognizer)
    }

    @objc private func handleDoubleTapGesture(sender: DoubleTapGestureRecognizer) {
        guard let cardStacksView = superview as? UIStackView else { return }
        guard let indexOfCardStack = cardStacksView.arrangedSubviews.firstIndex(of: self) else { return }
        
        guard let cardView = sender.view else { return }
        guard let indexOfCard = subviews.firstIndex(of: cardView) else { return }
        
        let indexPath = IndexPath(item: indexOfCard, section: indexOfCardStack)
        let userInfo = [Notification.InfoKey.indexPathOfCard: indexPath]
        NotificationCenter.default.post(name: .cardDidDoubleTapped, object: self, userInfo: userInfo)
    }

    func pop(at indexOfCard: Int) -> CardView? {
        guard subviews.indices.contains(indexOfCard) else { return nil }
        guard let cardView = subviews[indexOfCard] as? CardView else { return nil }
        removeDoubleTapGestureRecognizer(from: cardView)
        cardView.removeFromSuperview()
        return cardView
    }

    func pop(from indexOfCard: Int) -> [CardView]? {
        guard subviews.indices.contains(indexOfCard) else { return nil }
        let views = subviews[indexOfCard...]
        var cardViewsPopped = [CardView]()
        for view in views {
            guard let cardView = view as? CardView else { continue }
            removeDoubleTapGestureRecognizer(from: cardView)
            cardView.removeFromSuperview()
            cardViewsPopped.append(cardView)
        }
        return cardViewsPopped
    }

    func push(cardView: CardView) {
        if subviews.isEmpty {
            cardView.frame.origin = .zero
        }
        if let lastCardView = subviews.last {
            cardView.frame.origin.y = lastCardView.frame.origin.y + 20
        }
        addSubview(cardView)
        addDoubleTapGestureRecognizer(to: cardView)
    }

}

extension Notification.Name {
    static let cardDidDoubleTapped = Notification.Name("cardDidDoubleTapped")
}

extension Notification.InfoKey {
    static let indexOfCard = "indexOfCard"
    static let indexOfCardStack = "indexOfCardStack"
    static let indexPathOfCard = "indexPathOfCard"
}
