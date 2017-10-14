//
//  Bundle+Additions.swift
//  Extensions
//
//  Created by mac on 2017/9/20.
//  Copyright © 2017年 com.cnlod.cn. All rights reserved.
//

import UIKit

public extension Bundle {
    //MARK:当前版本
    var lca_currentVersion:String? {
        get {
             return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }
    }
    //MARK:Build版本号
    var lca_buildVersion:Double? {
        get {
            guard let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String  else {
                return nil
            }
            return Double(buildString)
        }
    }
    //MARK:获取项目名称
    var lca_projectName:String? {
        get {
            guard let projectName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String else {
                return nil
            }
            return projectName
        }
    }
    //MARK:获取当前设备的启动图片
    var lca_launchImage:UIImage? {
        get {
            guard let images = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: String]] else {
                return nil
            }
            
            // 根据屏幕尺寸过滤数组
            let result = images.filter { (dict) -> Bool in
                let imageSize = CGSizeFromString(dict["UILaunchImageSize"]!)
                let orientation = dict["UILaunchImageOrientation"]!
                
                return orientation == "Portrait" && imageSize.equalTo(UIScreen.main.bounds.size)
            }
            
            // 获取图像名称
            guard let imageName = result.first?["UILaunchImageName"] else {
                return nil
            }
            
            return UIImage(named: imageName)
        }
    }
    
    
}
