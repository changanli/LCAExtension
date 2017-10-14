//
//  WKWebView.swift
//  patient
//
//  Created by mac on 2017/9/21.
//  Copyright © 2017年 cnlod. All rights reserved.
//

import UIKit
import WebKit

public extension WKWebView {
    
    //MARK:删除所有的缓存和Cookie
    class func lca_cleanWKWebViewAllCacheCookie() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
            let dateFrom = Date(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom, completionHandler: {
                
            })
        } else {
            // Fallback on earlier versions
        }
    }
    //MARK:不删除Cooke，删除其他缓存
    class func lca_cleanWKWenViewOnlyCache() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes:Set<String> = [WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeOfflineWebApplicationCache,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeSessionStorage,WKWebsiteDataTypeIndexedDBDatabases,WKWebsiteDataTypeWebSQLDatabases]
            let dateFrom = Date(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom, completionHandler: {
                
            })
        } else {
            // Fallback on earlier versions
        }
    }
}

