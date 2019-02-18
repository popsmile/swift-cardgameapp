//
//  CardStacksView.swift
//  CardGameApp
//
//  Created by 윤지영 on 29/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class CardStacksView: UIStackView {

    required init(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    convenience init(frame: CGRect, viewModel: CardStacksViewModel) {
        self.init(frame: frame)
        configureLayout()
        createCardStackViews(with: viewModel)
    }

    private func configureLayout() {
        spacing = 5
        distribution = .fillEqually
    }

    private func createCardStackViews(with viewModel: CardStacksViewModel) {
        viewModel.iterateCardStackViewModels { [unowned self] cardStackViewModel in
            let cardStackView = CardStackView(frame: .zero, viewModel: cardStackViewModel)
            self.addArrangedSubview(cardStackView)
        }
    }

    func pop(at indexPath: IndexPath) -> [CardView]? {
        guard subviews.indices.contains(indexPath.section) else { return nil }
        guard let cardStackView = subviews[indexPath.section] as? CardStackView else { return nil }
        return cardStackView.pop(from: indexPath.item, toTheEnd: false)
    }

    func push(_ cardView: CardView, at indexOfCardStack: Int) {
        guard subviews.indices.contains(indexOfCardStack) else { return }
        guard let cardStackView = subviews[indexOfCardStack] as? CardStackView else { return }
        cardStackView.push(cardView: cardView)
    }

    func moveCardView(at indexPath: IndexPath, to indexOfCardStackToMove: Int) {
        guard subviews.indices.contains(indexPath.section) else { return }
        guard subviews.indices.contains(indexOfCardStackToMove) else { return }
        guard let cardStackView = subviews[indexPath.section] as? CardStackView else { return }
        guard let cardStackViewToMove = subviews[indexOfCardStackToMove] as? CardStackView else { return }
        
        guard let cardViews = cardStackView.pop(from: indexPath.item) else { return }
        cardViews.forEach { cardStackViewToMove.push(cardView: $0) }
    }

}
