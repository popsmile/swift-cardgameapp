//
//  CardStackView.swift
//  CardGameApp
//
//  Created by 윤지영 on 28/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class CardStackView: UIView {
    private var viewModel: CardStackViewModel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect, viewModel: CardStackViewModel) {
        self.init(frame: frame)
        self.viewModel = viewModel
        makeCardViews()
    }

    func push(_ cardView: CardView) {
        addSubview(cardView)
    }

    func pop() -> CardView? {
        guard let cardView = subviews.last as? CardView else { return nil }
        cardView.removeFromSuperview()
        return cardView
    }

    private func makeCardViews() {
        viewModel.iterateCardViewModels { [unowned self] cardViewModel in
            let width = self.frame.width
            let size = CGSize(width: width, height: width * 1.27)
            var frame = CGRect(origin: CGPoint(), size: size)
            if let lastCardView = subviews.last {
                frame.origin.y = lastCardView.frame.origin.y + 20
            }
            let cardView = CardView(frame: frame, viewModel: cardViewModel)
            self.addSubview(cardView)
        }
    }

}
