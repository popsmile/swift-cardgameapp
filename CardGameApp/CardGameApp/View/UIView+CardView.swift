//
//  UIImageView+CardView.swift
//  CardGameApp
//
//  Created by Mrlee on 2018. 1. 29..
//  Copyright © 2018년 Napster. All rights reserved.
//

import UIKit

extension UIView {
    func makeViewPoint(columnIndex: CGFloat, rowIndex: CGFloat) -> CGPoint {
        let xPoint = (UIView.cardSize().width + UIView.marginBetweenCard()) * columnIndex + UIView.marginBetweenCard()
        let yPoint = UIApplication.shared.statusBarFrame.height + (UIView.cardSize().height * rowIndex)
        return CGPoint(x: xPoint, y: yPoint)
    }
    
    func getCard() -> String {
        return self.description
    }
    
    func makeBasicView() {
        self.bounds = CGRect(origin: CGPoint.zero, size: UIView.cardSize())
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func makeCardView() {
        self.makeCardView(index: 0, yPoint: 0)
    }
    
    func makeZeroOrigin() {
        self.frame.origin = CGPoint.zero
    }
    
    func makeCardView(index: CGFloat) {
        self.makeCardView(index: index, yPoint: UIApplication.shared.statusBarFrame.height)
    }
    
    func makeCardView(yPoint: CGFloat) {
        self.makeBasicView()
        self.frame.origin = CGPoint(x: 0, y: yPoint)
    }
    
    func makeCardView(index: CGFloat, yPoint: CGFloat) {
        let xPoint = ((UIView.cardSize().width + UIView.marginBetweenCard()) * CGFloat(index)) + UIView.marginBetweenCard()
        self.makeBasicView()
        self.frame.origin = CGPoint(x: xPoint, y: yPoint)
    }
    
    class func cardSize() -> CGSize {
        let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
        let marginRatio: CGFloat = 70
        let cardColumns: CGFloat = 7
        let cardWidth = (screenWidth / cardColumns) - (screenWidth / marginRatio)
        let cardHeight = (screenWidth / cardColumns) * 1.27
        return CGSize(width: cardWidth, height: cardHeight)
    }
    
    class func marginBetweenCard() -> CGFloat {
        let cardFrame = UIView.cardSize()
        let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
        let margin = (screenWidth - (cardFrame.width * 7)) / 8
        return margin
    }
    
    func refreshButton() {
        guard let image = UIImage(named: "cardgameapp-refresh-app") else { return }
        let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.width
        let yPoint = UIApplication.shared.statusBarFrame.height
        let ratio = screenWidth / 1000
        let imageWidth = ratio * image.size.width
        self.frame = CGRect(x: screenWidth - (imageWidth + (imageWidth / CGFloat(3))),
                            y: yPoint + 20,
                            width: ratio * image.size.width,
                            height: ratio * image.size.height)
        self.contentMode = UIViewContentMode.scaleAspectFit
    }
}
