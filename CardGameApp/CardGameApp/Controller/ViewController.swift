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
        NotificationCenter.default.addObserver(self, selector: #selector(handleDoubleTap(_:)), name: .cardDidDoubleTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTap(_:)), name: .cardDeckDidTapped, object: nil)
    }

    @objc private func handleDoubleTap(_ notification: Notification) {
        print("더블탭: \(notification.userInfo!)")
        guard let indexOfCard = notification.userInfo?[Notification.InfoKey.indexOfCard] as? Int,
              let indexOfCardStack = notification.userInfo?[Notification.InfoKey.indexOfCardStack] as? Int else { return }
        
        if let space = cardGameViewModel.moveToSpace(indexOfCard: indexOfCard, indexOfCardStack: indexOfCardStack) {
            cardGameView.moveToSpace(indexOfCard: indexOfCard, indexOfCardStack: indexOfCardStack, to: space)
        }
        
        if let stack = cardGameViewModel.moveToStack(indexOfCard: indexOfCard, indexOfCardStack: indexOfCardStack) {
            cardGameView.moveToStack(indexOfCard: indexOfCard, indexOfCardStack: indexOfCardStack, to: stack)
        }
    }

    @objc private func handleTap(_ notification: Notification) {
        cardGameViewModel.openCardFromCardDeck()
        cardGameView.moveCardViewFromCardDeckView()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            cardGameView.reset()
            cardGameViewModel.reset()
        }
    }

}
