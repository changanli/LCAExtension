//
//  UIWebView+Additions.swift
//  patient
//
//  Created by mac on 2017/9/21.
//  Copyright © 2017年 cnlod. All rights reserved.
//

import UIKit

public extension UIWebView {
    //MARK:清理缓存 
    class func lca_cleanUIWebViewCache() {
        //web页面更改时，如果不清除缓存没有办法看到web页面的变化
        //清除Cookies
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        //清除webView缓存
        URLCache.shared.removeAllCachedResponses()
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
        cache.memoryCapacity = 0
        cache.diskCapacity = 0
    }
}
