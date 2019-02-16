//
//  CardDeckView.swift
//  CardGameApp
//
//  Created by 윤지영 on 29/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class CardDeckView: UIImageView {

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

    private func addTapGestureRecognizer(to view: CardView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTap() {
        NotificationCenter.default.post(name: .cardDeckDidTapped, object: self)
    }

    func push(_ cardView: CardView) {
        addSubview(cardView)
        addTapGestureRecognizer(to: cardView)
    }

    func pop() -> CardView? {
        guard let cardView = subviews.last as? CardView else { return nil }
        cardView.removeFromSuperview()
        return cardView
    }

}

extension Notification.Name {
    static let cardDeckDidTapped = NSNotification.Name("cardDeckDidTapped")
}
