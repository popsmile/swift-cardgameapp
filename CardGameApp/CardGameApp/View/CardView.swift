//
//  CardView.swift
//  CardGameApp
//
//  Created by 윤지영 on 23/01/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class CardView: UIImageView {
    private var viewModel: CardViewModel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    convenience init(frame: CGRect, viewModel: CardViewModel) {
        self.init(frame: frame)
        self.viewModel = viewModel
        image = UIImage(named: viewModel.imageName)
    }

    private func setUp() {
        roundCorners()
    }

    private func roundCorners() {
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }

}
