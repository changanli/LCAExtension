//
//   UIDevice+Additions.swift
//  Extensions
//
//  Created by mac on 2017/9/20.
//  Copyright © 2017年 com.cnlod.cn. All rights reserved.
//

import UIKit
import CoreTelephony

public extension UIDevice {
    //MARK:当前系统版本
    static var lca_systemVersion:Double {
        get {
            return Double(UIDevice.current.systemVersion) ?? 0
        }
    }
    
    //MARK:是否iPad
    var lca_isPad:Bool {
        get {
          return UI_USER_INTERFACE_IDIOM() == .pad
        }
    }
    //MARK:是都iPhone
    var lca_isPhone:Bool {
        get {
           return UI_USER_INTERFACE_IDIOM() == .phone
        }
    }
    //MARK:获取设备machineModel "iPhone6,1"
    // http://theiphonewiki.com/wiki/Models
    var lca_machineModel:String{
        get{
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            
            return identifier
        }
    }
    var lca_isIphoneX:Bool {
        get {
            return UIDevice.current.lca_machineName == "iPhone X" || UIDevice.current.lca_isIphoneXSimulator 
        }
    }
    //MARK:模拟器是否是iPhoneX
    var lca_isIphoneXSimulator:Bool {
        get {
            if (UIDevice.current.lca_machineName == "Simulator x64" || UIDevice.current.lca_machineName == "Simulator x86") && UIDevice.current.lca_isPhone && UIScreen.main.bounds.size.height >= 812 {
                return true
            }
            
            return false
        }
    }
    //MARK:当前设备型号 iPhone 5s
    // http://theiphonewiki.com/wiki/Models
    var lca_machineName:String {
        get {
            
            switch lca_machineModel {
                case "Watch1,1":return "Apple Watch 38mm"
                case "Watch1,2":return "Apple Watch 42mm"
                case "Watch2,3":return "Apple Watch Series 2 38mm"
                case "Watch2,4":return "Apple Watch Series 2 42mm"
                case "Watch2,6":return "Apple Watch Series 1 38mm"
                case "Watch2,7":return "Apple Watch Series 1 42mm"
                case "Watch3,1":return "Apple Watch Series 3 38mm"
                case "Watch3,2":return "Apple Watch Series 3 42mm"
                case "Watch3,3":return "Apple Watch Series 3 38mm"
                case "Watch3,4":return "Apple Watch Series 3 42mm"
                
                case "iPod1,1":return "iPod touch 1"
                case "iPod2,1":return "iPod touch 2"
                case "iPod3,1":return "iPod touch 3"
                case "iPod4,1":return "iPod touch 4"
                case "iPod5,1":return "iPod touch 5"
                case "iPod7,1":return "iPod touch 6"
                
                case "iPhone1,1":return "iPhone 1G"
                case "iPhone1,2":return "iPhone 3G"
                case "iPhone2,1":return "iPhone 3GS"
                case "iPhone3,1":return "iPhone 4 (GSM)"
                case "iPhone3,2":return "iPhone 4"
                case "iPhone3,3":return "iPhone 4 (CDMA)"
                case "iPhone4,1":return "iPhone 4S"
                case "iPhone5,1":return "iPhone 5"
                case "iPhone5,2":return "iPhone 5"
                case "iPhone5,3":return "iPhone 5c"
                case "iPhone5,4":return "iPhone 5c"
                case "iPhone6,1":return "iPhone 5s"
                case "iPhone6,2":return "iPhone 5s"
                case "iPhone7,1":return "iPhone 6 Plus"
                case "iPhone7,2":return "iPhone 6"
                case "iPhone8,1":return "iPhone 6s"
                case "iPhone8,2":return "iPhone 6s Plus"
                case "iPhone9,1":return "iPhone 7"
                case "iPhone9,2":return "iPhone 7 Plus"
                case "iPhone9,3":return "iPhone 7"
                case "iPhone9,4":return "iPhone 7 Plus"
                case "iPhone10,1":return "iPhone 8"
                case "iPhone10,4":return "iPhone 8"
                case "iPhone10,2":return "iPhone 8 Plus"
                case "iPhone10,5":return "iPhone 8 Plus"
                case "iPhone10,3":return "iPhone X"
                case "iPhone10,6":return "iPhone X"
                
                case "iPad1,1":return "iPad 1"
                case "iPad2,1":return "iPad 2 (WiFi)"
                case "iPad2,2":return "iPad 2 (GSM)"
                case "iPad2,3":return "iPad 2 (CDMA)"
                case "iPad2,4":return "iPad 2"
                case "iPad2,5":return "iPad mini 1"
                case "iPad2,6":return "iPad mini 1"
                case "iPad2,7":return "iPad mini 1"
                case "iPad3,1":return "iPad 3 (WiFi)"
                case "iPad3,2":return "iPad 3 (4G)"
                case "iPad3,3":return "iPad 3 (4G)"
                case "iPad3,4":return "iPad 4"
                case "iPad3,5":return "iPad 4"
                case "iPad3,6":return "iPad 4"
                case "iPad4,1":return "iPad Air"
                case "iPad4,2":return "iPad Air"
                case "iPad4,3":return "iPad Air"
                case "iPad4,4":return "iPad mini 2"
                case "iPad4,5":return "iPad mini 2"
                case "iPad4,6":return "iPad mini 2"
                case "iPad4,7":return "iPad mini 3"
                case "iPad4,8":return "iPad mini 3"
                case "iPad4,9":return "iPad mini 3"
                case "iPad5,1":return "iPad mini 4"
                case "iPad5,2":return "iPad mini 4"
                case "iPad5,3":return "iPad Air 2"
                case "iPad5,4":return "iPad Air 2"
                case "iPad6,3":return "iPad Pro (9.7 inch)"
                case "iPad6,4":return "iPad Pro (9.7 inch)"
                case "iPad6,7":return "iPad Pro (12.9 inch)"
                case "iPad6,8":return "iPad Pro (12.9 inch)"
                case "iPad6,11":return "iPad 5"
                case "iPad6,12":return "iPad 5"
                case "iPad7,1":return "iPad Pro2 (12.9-inch)"
                case "iPad7,2":return "iPad Pro2 (12.9-inch)"
                case "iPad7,3":return"iPad Pro (10.5-inch)"
                case "iPad7,4":return "iPad Pro (10.5-inch)"
                
                case "AppleTV2,1":return "Apple TV 2"
                case "AppleTV3,1":return "Apple TV 3"
                case "AppleTV3,2":return "Apple TV 3"
                case "AppleTV5,3":return "Apple TV 4"
                case "AppleTV6,2":return "Apple TV 4K"
                
                case "AudioAccessory1,1":return "HomePod"
                
                case "i386":return "Simulator x86"
                case "x86_64":return "Simulator x64"
                
                default:
                    return "未知"
            }
        }
    }
    //MARK:获取运营商 mobile:移动 unicom:联通 telcom:电信
    var lca_carrier:String? {
        get {
            var result = "未知"
            let info = CTTelephonyNetworkInfo()
            let carrier = info.subscriberCellularProvider
            if carrier == nil {
                return nil
            }
            
            guard let code = carrier!.mobileNetworkCode else {
                return nil
            }
            
            if code == "00 " || code == "02" || code == "07" {
                result = "mobile" //移动
            }
            if code == "01" || code == "06" {
                result = "unicom" //联通
            }
            if code == "03" || code == "05" {
                result = "telcom" //电信
            }
            
            return result
        }
    }
    
    var lca_systemUptime:Date {
        get {
            let time = ProcessInfo.processInfo.systemUptime
            return Date(timeIntervalSinceNow: 0-time)
        }
    }
    //MARK:获取磁盘空间 byte -1出现错误
    var lca_diskSpace:Int64 {
        get {
            do {
                let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
                let space = attrs[FileAttributeKey.systemSize] as! Int64
                return space
            } catch {
                print("未知错误")
                return -1
            }
        
        }
    }
    
    //MARK:获取剩余磁盘空间 byte -1出现错误
    var lca_diskSpaceFree:Int64 {
        get {
            do {
                let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
                let space = attrs[FileAttributeKey.systemFreeSize] as! Int64
                return space
            } catch {
                print("未知错误")
                return -1
            }

        }
    }
    //MARK:获取使用的磁盘空间 byte -1出现错误
    var lca_diskSpaceUsed:Int64 {
        get {
            if lca_diskSpace == -1 || lca_diskSpaceFree == -1 {
                return -1
            }
            let space = lca_diskSpace - lca_diskSpaceFree
            if space < 0 {
                return -1
            }
            return space
            
        }
    }
    
    //MARK:物理内存 byte -1 错误
    var lca_memoryTotal:UInt64 {
        get {
            let mem = ProcessInfo.processInfo.physicalMemory
            
            return mem
        }
    }
    
    
}
