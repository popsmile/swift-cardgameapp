//
//  CardBackUIImageView.swift
//  CardGameApp
//
//  Created by oingbong on 26/10/2018.
//  Copyright © 2018 oingbong. All rights reserved.
//

import UIKit

class CardImageView: UIImageView {
    private var card = Card(number: .ace, shape: .heart)
    
    init(card: Card, frame: CGRect) {
        super.init(image: card.image())
        self.card = card
        self.frame = frame
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(tapGestureRecognizer:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func tapAction(tapGestureRecognizer: UITapGestureRecognizer) {
        turnOver()
        moveToWaste()
    }
    
    func turnOver() {
        self.image = card.turnOver()
    }
    
    private func moveToWaste() {
        guard self.superview is StockView, let superView = self.superview else { return }
        guard superView.subviews.count > 0 else { return }
        let topView = superView.subviews[superView.subviews.count - 1]
        let name = Notification.Name(NotificationKey.name.moveToWaste)
        NotificationCenter.default.post(name: name, object: nil, userInfo: [NotificationKey.hash.view: topView])
    }
}