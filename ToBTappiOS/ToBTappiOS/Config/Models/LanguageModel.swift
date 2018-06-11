//
//  LanguageModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/5/18.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
//语言模型,参考网络通信接口文档
enum Language {
    case English
    case Korean
    case Japanese
    case Czech
    case Slovak
}

extension Language {
    //各个语言的显示
    var text: String {
        switch self {
        case .English:
            return "English"
        case .Korean:
            return "한국어"
        case .Japanese:
            return "日本語"
        case .Czech:
            return "Czech"
        case .Slovak:
            return "Slovak"
        }
    }
    //网页使用的多语言参数
    var webCode: String {
        switch self {
        case .English:
            return "en"
        case .Korean:
            return "ko_kr"
        case .Japanese:
            return "ja_jp"
        case .Czech:
            return "cz_ch"
        case .Slovak:
            return "sl_ak"
        }
    }
    //网络通信时使用的多语言参数
    var code: String {
        switch self {
        case .English:
            return "en"
        case .Korean:
            return "ko"
        case .Japanese:
            return "ja"
        case .Czech:
            return "cs"
        case .Slovak:
            return "sk"
        }
    }
    
    init(_ code: String) {
        if code.contains("ko") {
            self = .Korean
        } else if code.contains("ja") {
            self = .Japanese
        } else if code.contains("sk"){
            self = .Slovak
        } else if code.contains("cs") {
            self = .Czech
        } else {
            self = .English
        }
        
    }
}

struct LanguageModel {
    var language: Language
    var select: Bool
    
    
}
