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
}
