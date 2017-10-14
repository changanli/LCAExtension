//
//  UILabel+Extension.swift
//  text
//
//  Created by lichangan on 16/10/3.
//  Copyright © 2016年 lichangan. All rights reserved.
//

import UIKit

public extension UILabel {

    /// 创建 UILabel
    ///
    /// - parameter lca_text:      text
    /// - parameter lca_fontSize:  fontSize
    /// - parameter lca_color:     color
    /// - parameter lca_alignment: alignment，默认左对齐
    /// - parameter lca_numberOfLines: numberOfLines，默认0
    ///
    /// - returns: UILabel
    convenience init(lca_text:String?,lca_font:UIFont,lca_textColor:UIColor,lca_alignment:NSTextAlignment = .left,lca_numberOfLines:NSInteger = 1){
        
        self.init()
        
        if let text = lca_text {
            self.text = text
        }
        
        self.textColor = lca_textColor
        self.font = lca_font
        self.textAlignment = lca_alignment
        self.numberOfLines = lca_numberOfLines
        //自动调整大小
        sizeToFit()
    }
}
