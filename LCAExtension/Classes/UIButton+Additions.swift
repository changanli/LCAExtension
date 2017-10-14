//
//  UIButton+Extension.swift
//  Extensions
//
//  Created by lichangan on 2017/9/12.
//  Copyright © 2017年 com.cnlod.cn. All rights reserved.
//

import UIKit

public enum ButtonEdgeInsetsStyle {
    case top // image在上，label在下
    case left // image在左，label在右
    case bottom // image在下，label在上
    case right // image在右，label在左
}

public extension UIButton {
    
    convenience init(title:String?,titleColor:UIColor?,backgroundImage:UIImage?,font:UIFont,textAlignment:NSTextAlignment,target:Any?,action:Selector?,controlEvent:UIControlEvents?){
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        setBackgroundImage(backgroundImage, for: .normal)
        titleLabel?.font = font
        titleLabel?.textAlignment = textAlignment
        if target != nil && action != nil && controlEvent != nil {
            addTarget(target, action: action!, for: controlEvent!)
        }
    }
    /*
     *  设置button的titleLabel和imageView的布局样式，及间距
     *
     *  @param style titleLabel和imageView的布局样式
     *  @param space titleLabel和imageView的间距
     */
    //MARK:设置button中图片和文字的位置
    func lca_layoutButtonWithEdgeInset(frame:CGRect,style:ButtonEdgeInsetsStyle,imageTitleSpace space:CGFloat) {
        //http://www.jianshu.com/p/3052a3b14a4e
        self.frame = frame
        let imageWidth = self.imageView?.frame.size.width ?? 0
        let imageHeight = self.imageView?.frame.size.height ?? 0
        var labelWidth:CGFloat = 0.0
        var labelHeight:CGFloat = 0.0
        let systemVersion:Double = Double(UIDevice.current.systemVersion) ?? 0.0
        if systemVersion >= 8.0 {
            //ios8中titleLabel的size为0，用下面的这种设置
            labelWidth = self.titleLabel?.intrinsicContentSize.width ?? 0
            labelHeight = self.titleLabel?.intrinsicContentSize.height ?? 0
        }else{
            labelWidth = self.titleLabel?.frame.size.width ?? 0
            labelHeight = self.titleLabel?.frame.size.height ?? 0
        }
        
        //声明全局的imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        //根据style和space得到imageEdgeInsets和labelEdgeInsets
        var labelOffsetX:CGFloat = 0
        var labelOffsetY:CGFloat = 0
        var imageOffsetX:CGFloat = 0
        var imageOffsetY:CGFloat = 0
        
        switch style {
        case .top:
            labelOffsetX = (imageWidth+labelWidth/2)-(imageWidth+labelWidth)/2
            labelOffsetY = labelHeight/2
            imageOffsetX = (imageWidth+labelWidth)/2-imageWidth/2
            imageOffsetY = imageHeight/2
            imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            labelEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: -space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space/2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-space/2.0, left: -imageWidth, bottom: 0, right:0)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth-space/2.0, bottom: 0, right:imageWidth+space/2.0)
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }

    
}
