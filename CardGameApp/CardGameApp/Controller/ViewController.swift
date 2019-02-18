//
//  ViewController.swift
//  CardGameApp
//
//  Created by 윤지영 on 22/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var cardGameView: CardGameView!
    private var cardGameViewModel: CardGameViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setCardGameView()
        registerAsObserver()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func setBackground() {
        guard let image = UIImage(named: "bg_pattern.png") else { return }
        self.view.backgroundColor = UIColor(patternImage: image)
    }

    private func setCardGameView() {
        cardGameViewModel = CardGameViewModel()
        cardGameView = CardGameView(frame: view.frame, viewModel: cardGameViewModel)
        view.addSubview(cardGameView)
    }

    private func registerAsObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTapOfCardInDeck),
                                               name: .cardInDeckDidTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTouchOfRefreshImageInDeck),
                                               name: .refreshImageInDeckDidTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDoubleTapOfCardStacks(_:)),
                                               name: .cardDidDoubleTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDoubleTapOfCardPile),
                                               name: .cardPileDidDoubleTapped, object: nil)
    }

    @objc private func handleTapOfCardInDeck() {
        cardGameViewModel.openCardFromCardDeck()
        cardGameView.moveCardViewFromCardDeckView()
    }

    @objc private func handleTouchOfRefreshImageInDeck() {
        cardGameViewModel.moveCardViewModelsToCardDeckViewModel()
        cardGameView.moveCardViewsToCardDeckView()
    }

    @objc private func handleDoubleTapOfCardStacks(_ notification: Notification) {
        guard let indexPath = notification.userInfo?[Notification.InfoKey.indexPathOfCard] as? IndexPath else { return }
        if let space = cardGameViewModel.moveCardFromStackToSpace(cardAt: indexPath) {
            cardGameView.moveCardFromStackToSpace(indexPathOfCard: indexPath, to: space)
        }
        if let stack = cardGameViewModel.moveCardFromStackToStack(cardAt: indexPath) {
            cardGameView.moveCardFromStackToStack(indexPathOfCard: indexPath, to: stack)
        }
    }

    @objc private func handleDoubleTapOfCardPile() {
        if let space = cardGameViewModel.moveCardFromPileToSpace() {
            cardGameView.moveCardFromPileToSpace(at: space)
        }
        if let stack = cardGameViewModel.moveCardFromPileToStack() {
            cardGameView.moveCardFromPileToStack(at: stack)
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            cardGameView.reset()
            cardGameViewModel.reset()
        }
    }

}
