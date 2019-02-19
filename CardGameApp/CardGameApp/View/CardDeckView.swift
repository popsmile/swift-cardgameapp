//
//  CardDeckView.swift
//  CardGameApp
//
//  Created by 윤지영 on 29/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class CardDeckView: UIImageView {
    private let spacing: CGFloat = 0.1

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }

    convenience init(frame: CGRect, viewModel: CardDeckViewModel) {
        self.init(frame: frame)
        createCardViews(with: viewModel)
        registerAsObserver(of: viewModel)
        setTapGestureRecognizer()
    }

    private func createCardViews(with viewModel: CardDeckViewModel) {
        viewModel.iterateCardViewModels { [unowned self] cardViewModel in
            let cardView = CardView(frame: self.bounds, viewModel: cardViewModel)
            self.push(cardView)
        }
    }

    private func registerAsObserver(of viewModel: CardDeckViewModel) {
        NotificationCenter.default.addObserver(self, selector: #selector(setRefreshImage), name: .cardDeckWillBeEmpty, object: viewModel)
    }

    @objc private func setRefreshImage() {
        image = UIImage(named: "cardgameapp-refresh-app")
    }

    private func setTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOfRefreshImage))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTapOfRefreshImage() {
        NotificationCenter.default.post(name: .refreshImageInDeckDidTapped, object: self)
    }

    private func addTapGestureRecognizer(to cardView: CardView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOfCardView))
        cardView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func removeTapGestureRecognizer(from cardView: CardView) {
        guard let tapGestureRecognizer = cardView.gestureRecognizers?.first else { return }
        cardView.removeGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTapOfCardView() {
        NotificationCenter.default.post(name: .cardInDeckDidTapped, object: self)
    }

    func push(_ cardView: CardView) {
        cardView.frame.origin = .zero
        if let lastCardView = subviews.last {
            cardView.frame.origin.x = lastCardView.frame.origin.x + spacing
            cardView.frame.origin.y = lastCardView.frame.origin.y + spacing
        }
        addSubview(cardView)
        addTapGestureRecognizer(to: cardView)
    }

    func pop() -> CardView? {
        guard let cardView = subviews.last as? CardView else { return nil }
        removeTapGestureRecognizer(from: cardView)
        cardView.removeFromSuperview()
        return cardView
    }

}

extension Notification.Name {
    static let cardInDeckDidTapped = NSNotification.Name("cardDeckDidTapped")
    static let refreshImageInDeckDidTapped = Notification.Name("refreshImageInDeckDidTapped")
}
