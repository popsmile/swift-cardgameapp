//
//  Keyword.swift
//  CardGameApp
//
//  Created by 권재욱 on 2018. 3. 22..
//  Copyright © 2018년 권재욱. All rights reserved.
//

import Foundation

struct Key {
    
    enum Img : String {
        case background
        case refresh
        
        var name : String {
            switch self {
            case .background:
                return "bg_pattern"
            case .refresh:
                return "refresh"
            }
        }
    }
    
    enum Card : Int {
        case foundations
        case baseCards
        case lastIndex
        case noStack
        
        var count: Int {
            switch self {
            case .foundations: return 4
            case .baseCards: return 7
            case .lastIndex: return 6
            case .noStack: return 0
            }
        }
    }
    
}
