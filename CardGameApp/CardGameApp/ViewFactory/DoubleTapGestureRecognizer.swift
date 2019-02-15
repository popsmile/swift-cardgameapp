//
//  DoubleTapGestureRecognizer.swift
//  CardGameApp
//
//  Created by 윤지영 on 15/02/2019.
//  Copyright © 2019 윤지영. All rights reserved.
//

import UIKit

class DoubleTapGestureRecognizer: UITapGestureRecognizer {

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        numberOfTapsRequired = 2
    }

}
