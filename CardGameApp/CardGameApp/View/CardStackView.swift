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
        addDoubleTapGestureRecognizer()
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

    private func addDoubleTapGestureRecognizer() {
        for cardView in subviews {
            let doubleTapGestureRecognizer = DoubleTapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(sender:)))
            cardView.addGestureRecognizer(doubleTapGestureRecognizer)
        }
    }

    @objc private func handleDoubleTapGesture(sender: DoubleTapGestureRecognizer) {
        guard let cardStacksView = superview as? UIStackView else { return }
        guard let indexOfCardStack = cardStacksView.arrangedSubviews.firstIndex(of: self) else { return }
        
        guard let cardView = sender.view else { return }
        guard let indexOfCard = subviews.firstIndex(of: cardView) else { return }
        
        let userInfo = [Notification.InfoKey.indexOfCard: indexOfCard,
                        Notification.InfoKey.indexOfCardStack: indexOfCardStack]
        NotificationCenter.default.post(name: .cardDidDoubleTapped, object: self, userInfo: userInfo)
    }

}

extension Notification.Name {
    static let cardDidDoubleTapped = Notification.Name("cardDidDoubleTapped")
}

extension Notification.InfoKey {
    static let indexOfCard = "indexOfCard"
    static let indexOfCardStack = "indexOfCardStack"
}
