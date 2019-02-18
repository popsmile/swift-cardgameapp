//
//  CardStackView.swift
//  CardGameApp
//
//  Created by 윤지영 on 28/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class CardStackView: UIView {
    private let spacing: CGFloat = 20

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect, viewModel: CardStackViewModel) {
        self.init(frame: frame)
        createCardViews(with: viewModel)
        setDoubleTapGestureRecognizers()
    }

    private func createCardViews(with viewModel: CardStackViewModel) {
        viewModel.iterateCardViewModels { [unowned self] cardViewModel in
            var frame = CGRect(origin: .zero, size: CardViewLayout.size)
            if let lastCardView = subviews.last {
                frame.origin.y = lastCardView.frame.origin.y + spacing
            }
            let cardView = CardView(frame: frame, viewModel: cardViewModel)
            self.addSubview(cardView)
        }
    }

    private func setDoubleTapGestureRecognizers() {
        if let cardViews = subviews as? [CardView] {
        cardViews.forEach { addDoubleTapGestureRecognizer(to: $0) }
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

    func push(cardView: CardView) {
        if subviews.isEmpty {
            cardView.frame.origin = .zero
        }
        if let lastCardView = subviews.last {
            cardView.frame.origin.y = lastCardView.frame.origin.y + spacing
        }
        addSubview(cardView)
        addDoubleTapGestureRecognizer(to: cardView)
    }

    func pop(from index: Int, toTheEnd: Bool = true) -> [CardView]? {
        guard subviews.indices.contains(index) else { return nil }
        let lastIndex = toTheEnd ? subviews.count : index + 1
        var removed = [CardView]()
        for _ in index..<lastIndex {
            guard let cardView = subviews.last as? CardView else { continue }
            removeDoubleTapGestureRecognizer(from: cardView)
            cardView.removeFromSuperview()
            removed.append(cardView)
        }
        return removed.reversed()
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
