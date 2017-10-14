//
//  UIAlertController+Additions.swift
//  Extensions
//
//  Created by lichangan on 2017/9/12.
//  Copyright © 2017年 com.cnlod.cn. All rights reserved.
//

import UIKit

public extension UIAlertController {
    
    /**
     *  确定 取消操作
     *
     *  @param target  目标
     *  @param title   提示的标题
     *  @param message 提示的消息
     *  @param confirmHandler 确定的操作
     */
    class func chooseAlert(target:UIViewController,title:String?,message:String?,cancel:String?="取消",confirm:String?="确认",confirmHandler:@escaping (()->Void)){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancel ?? "取消", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: confirm ?? "确认", style: .default) {(_) in
           confirmHandler()
        }
        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)
        target.present(alertVC, animated: true) { 
            
        }
    }
    /**
     *  简单的警告提示框
     *
     *  @param title   提示标题
     *  @param message 提示消息
     *  @param confirm 确认标题
     *  @param confirmHandler 确定的操作
     *  @param target  目标
     */
    class func simpleAlert(target:UIViewController,title:String?,message:String?,confirm:String,confirmHandler:@escaping (()->Void)) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirm, style: .default) {(_) in
            target.dismiss(animated: true, completion: { 
               
            })
             confirmHandler()
        }
        alertVC.addAction(confirmAction)
        target.present(alertVC, animated: true) { 
            
        }
        
    }
    
}
