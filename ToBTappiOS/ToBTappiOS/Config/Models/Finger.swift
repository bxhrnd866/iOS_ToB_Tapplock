//
//  Finger.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/13.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import Foundation

//手指模型+多语言
enum Finger: Int {
    case thumb = 1
    case indexFinger = 2
    case middleFinger = 3
    case ringFinger = 4
    case littleFinger = 5
}

extension Finger {
    var text: String {
        switch self {

        case .thumb:
            return R.string.localizable.thumbFinger()
        case .indexFinger:
            return R.string.localizable.indexFinger()
        case .middleFinger:
            return R.string.localizable.middleFinger()
        case .ringFinger:
            return R.string.localizable.ringFinger()
        case .littleFinger:
            return R.string.localizable.littleFinger()
        }
    }

//    var type:{}
}

//手模型+多语言
enum Hand: Int {
    case left = 1
    case right = 2
}

extension Hand {
    var text: String {
        switch self {
        case .left:
            return R.string.localizable.leftHand()
        case .right:
            return R.string.localizable.rightHand()
        }

    }

}
