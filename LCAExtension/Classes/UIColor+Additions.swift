//
//  UIColor+Extension.swift
//
//  Created by lichangan on 16/6/28.
//  Copyright © 2016年 lca. All rights reserved.
//

import UIKit

public extension UIColor {

    /// 使用十六进制数值转换成对应颜色
    /// - parameter lca_hex: 十六进制整数 0xFFC00F =>
    /// 1111 1111 1101 0000 0000 1111
    /// 0000 0000 1111 1111 0000 0000
    /// 0000 0000 0000 0000 1111 1111
    convenience init(lca_hex:UInt32) {
        let r = (lca_hex & 0xFF0000) >> 16
        let g = (lca_hex & 0x00FF00) >> 8
        let b = (lca_hex & 0x0000FF)
        
        self.init(lca_r: CGFloat(r), lca_g: CGFloat(g), lca_b: CGFloat(b))
    }
    /// 使用 lca_r / lca_g / lca_b 的整数生成颜色
    ///
    /// - parameter r: r
    /// - parameter g: g
    /// - parameter b: b
    ///
    /// - returns: UIColor
    //MARK:rgb
    convenience init(lca_r: CGFloat, lca_g: CGFloat, lca_b: CGFloat) {
        self.init(red: lca_r / 255.0, green: lca_g / 255.0, blue: lca_b / 255.0, alpha: 1.0)
    }
    //MARK:rgba
    convenience init(lca_r: CGFloat, lca_g: CGFloat, lca_b: CGFloat,lca_a:CGFloat) {
        self.init(red: lca_r / 255.0, green: lca_g / 255.0, blue: lca_b / 255.0, alpha: lca_a)
    }

    /// 生成随机颜色
    ///
    /// - returns: UIColor
    //MARK:生成随机图片
    class func lca_randomColor() -> UIColor {
       return UIColor(lca_r: CGFloat(arc4random() % 256), lca_g: CGFloat(arc4random() % 256), lca_b: CGFloat(arc4random() % 256))
    }
    //MARK:生成渐变色和渐变图片
    class func lca_gradientColor(colors:[CGColor],startPoint:CGPoint,endPoint:CGPoint,frame:CGRect)->(gradientColor:UIColor,gradientImage:UIImage) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = frame
        let gradientView = UIView(frame: frame)
        gradientView.layer.addSublayer(gradientLayer)
        let gradientImage = lca_drawImage(view: gradientView)
        let gradientColor = UIColor(patternImage: gradientImage)
        return (gradientColor,gradientImage)
    }
    
    //根据view生成一张图片
    private class func lca_drawImage(view:UIView)->UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, view.layer.contentsScale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}
