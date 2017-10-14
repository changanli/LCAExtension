//
//  UIView+Extension.swift
//  Extensions
//
//  Created by mac on 2017/9/12.
//  Copyright © 2017年 com.cnlod.cn. All rights reserved.
//

import UIKit

public extension UIView {
    //MARK:lca_x
    var lca_x:CGFloat {
        get {
            return frame.origin.x
        }
        set{
            var frame = self.frame
            frame.origin.x = lca_x
            self.frame = frame
        }
    }
    //MARK:lca_y
    var lca_y:CGFloat {
        get {
            return frame.origin.y
        }
        set{
            var frame = self.frame
            frame.origin.y = lca_y
            self.frame = frame
        }
    }
    //MARK:lca_centerX
    var lca_centerX:CGFloat {
        get {
            return center.x
        }
        
        set {
            center.x = lca_centerX
        }
    }
    //MARK:lca_centerY
    var lca_centerY:CGFloat {
        get {
            return center.y
        }
        set{
            center.y = lca_centerY
        }
    }
    //MARK:lca_width
    var lca_width:CGFloat {
        get {
            return frame.size.width
        }
        set{
            var frame = self.frame
            frame.size.width = lca_width
            self.frame = frame
        }
    }
    //MARK: lca_height
    var lca_height:CGFloat {
        get {
            return frame.size.height
        }
        set{
            var frame = self.frame
            frame.size.height = lca_height
            self.frame = frame
        }
    }
    //MARK: lca_size
    var lca_size:CGSize {
        get {
            return frame.size
        }
        set {
            var frame = self.frame
            frame.size = lca_size
            self.frame = frame
        }
    }
}


public extension UIView {
    //MARK:生成圆角
    func lca_makeRoundCorner(cornerRadius:CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    //MARK:截屏生成Image
    func lca_snapshotImage()->UIImage {
        UIGraphicsBeginImageContextWithOptions(lca_size, isOpaque, 0)
        let context = UIGraphicsGetCurrentContext()
        layer.render(in: context!)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return snap!
    }
    
    //MARK:截屏:生成PDF
    func lca_snapshotPDF()->Data? {
        let data = Data()
        var tmpBounds = bounds
        let consumer = CGDataConsumer(data: data as! CFMutableData)
        let context = CGContext(consumer: consumer!, mediaBox: &tmpBounds, nil)
        if context == nil {
            return nil
        }
        context!.beginPDFPage(nil)
        context!.translateBy(x: 1.0, y: tmpBounds.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        layer.render(in: context!)
        context?.endPage()
        context?.closePDF()
        
        return data
        
    }
    //MARK:设置shadow
    func lca_setLayerShadow(color:UIColor,offset:CGSize,radius:CGFloat){
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    //MARK:移除所有的子控件
    func lca_removeAllSubviews() {
        while (subviews.count>0) {
            subviews.last?.removeFromSuperview()
        }
    }
    //MARK:把前view的坐标转换为指定view上的坐标
    func lca_convert(point:CGPoint,toView:UIView)->CGPoint?{
        let from = isKind(of: UIWindow.self) ? self : self.window
        let to = toView.isKind(of: UIWindow.self) ? toView : toView.window
        if !(from != nil) || !(to != nil) || from == to {
           return convert(point, to: toView)
        }
        var tmpPoint:CGPoint = point
        tmpPoint = convert(tmpPoint, to: from)
        guard let toPoint = to?.convert(tmpPoint, from: from) else {
            return nil
        }
        tmpPoint = toPoint
        tmpPoint = toView.convert(tmpPoint, from: to)
        
        return tmpPoint
    }
    //MARK:将fromView的坐标转换成当前view坐标
    func lca_convert(point:CGPoint,fromView:UIView)->CGPoint? {
        let from = fromView.isKind(of: UIWindow.self) ? fromView : fromView.window
        let to = isKind(of: UIWindow.self) ? self : self.window
        
        if (from != nil) || (to != nil) || (from == to) {
            return convert(point, from: fromView)
        }
        var tmpPoint = point
        guard let fromPoint = from?.convert(tmpPoint, from: fromView) else {
            return nil
        }
        tmpPoint = fromPoint
        guard let toPoint = to?.convert(tmpPoint, from: from) else {
            return nil
        }
        tmpPoint = toPoint
        tmpPoint = convert(tmpPoint, from: to)
        return tmpPoint
    }
    //MARK:
    func lca_convert(rect:CGRect,toView:UIView)->CGRect? {
        let from = isKind(of: UIWindow.self) ? self : self.window
        let to = toView.isKind(of: UIWindow.self) ? toView : toView.window
        if !(from != nil) || !(to != nil) || from == to {
           return convert(rect, to: toView)
        }
        var tmpRect:CGRect = rect
        tmpRect = convert(tmpRect, to: from)
        guard let toRect = to?.convert(tmpRect, from: from) else {
            return nil
        }
        tmpRect = toRect
        tmpRect = toView.convert(tmpRect, from: to)

        return tmpRect
    }
    //MARK:
    func lca_convert(rect:CGRect,fromView:UIView)->CGRect? {
        let from = fromView.isKind(of: UIWindow.self) ? fromView : fromView.window
        let to = isKind(of: UIWindow.self) ? self : self.window
        
        if (from != nil) || (to != nil) || (from == to) {
            
            return convert(rect, from: fromView)
        }
        var tmpRect = rect
        guard let fromPoint = from?.convert(tmpRect, from: fromView) else {
            return nil
        }
        tmpRect = fromPoint
        guard let toPoint = to?.convert(tmpRect, from: from) else {
            return nil
        }
        tmpRect = toPoint
        tmpRect = convert(tmpRect, from: to)
        return tmpRect
    }
    
    
}

