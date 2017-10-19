//
//  String + Extension.swift
//  doctoro2o_ios_hz
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 cnlod. All rights reserved.
//

import UIKit

public extension String {
    
    //MARK:计算文本的长度
    // 计算文本的长度
    /// - Parameters:
    ///   - size: 文本占有的最大高度和最大宽度
    ///   - font: 字体大小
    /// - Returns: 文本占有的size
    func lca_calculate(size:CGSize,font:UIFont)->CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let arributes = [NSAttributedStringKey.font:font,NSAttributedStringKey.paragraphStyle:paragraphStyle]
        let size = (self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: arributes, context: nil).size
        return size
    }
    //MARK:是否含有Emoji表情
    //https://coderwall.com/p/adlwew/check-if-swift-string-contains-an-emoji-or-dingbat-charater
    var lca_containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F:   // Variation Selectors
                return true
            default:
                continue
            }
        }
        return false
    }

}
