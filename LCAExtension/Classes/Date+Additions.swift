//
//  Date+Extension.swift
//  Extensions
//
//  Created by mac on 2017/9/12.
//  Copyright © 2017年 com.cnlod.cn. All rights reserved.
//

import UIKit

/*
 通过Date得到的时间都是UTC时间(国际标准时间，同GTM时间)，不管设备的时区怎么变化。
 DateFormatter有timeZone属性，这个属性默认为当前系统时区，因此从Date转换成string的时候，
 系统计算时会自动在UTC时间上加上系统时区的偏差。
 除了DateFormatter有timeZone属性外，日历类NSCalendar也有timeZone属性。假设现在获取到一个日期Date
 对应的DateComponents,打印Date查看发现慢8个小时，而打印dateComponnets的hour查看返回不会慢8小时
 因为从Date->DateComponents需要借助NSCalendar对象，而calendar同样有个timeZone属性，默认是当前时区，
 转换过程中会自动加上时区偏差小时数
 
 平常做项目时服务器返回的都是本地时间，也就是中国时区的时间，而Date存储的是世界标准时间(UTC),如果将
 服务器时间转化为Date会出现8小时的偏差。
 如果将TimeZone设置为UTC就不会出现误差。
 
 如果服务端（东八区）下发时间，我们再客户端需要转为时间戳，建议，把DateFormatter的时区设定在东八区。Asia/Shanghai
 
 凡是有timeZone属性的控件，都能直接将UTC的Date日期直接转换为本地时间，比如UIDatePicker,给UIDatePicker设置date时，会自动加8小时时区
 通过UIDatePicker获得日期是用Date保存的，也就是UTC时间
 */

let yearMonthDayHourMinute1 = "yyyy-MM-dd HH:mm"
let yearMonthDayHourMinute2 = "yyyy年MM月dd HH:mm"
let yearMonthDay1 = "yyyy年MM月dd"
let yearMonthDay2 = "yyyy-MM-dd"
let hourMinte = "HH:mm"
let componentFlags:Set<Calendar.Component> = [Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second,Calendar.Component.weekday,Calendar.Component.weekdayOrdinal]

let kMinute:Double = 60
let kHour:Double = 3600
let kDay:Double = 86400
let kWeek:Double = 604800
let kYear:Double = 31556926

public extension Date {
    //MARK:返回UT8时间 传入时间 - 8小时
    static func lca_getDate(str:String,format:String)->Date? {
        return lca_getDate(str: str, format: format, timeZone: TimeZone.current)
    }
    //MARK:返回时间 根据TimeZone返回时间
    static func lca_getDate(str:String,format:String,timeZone:TimeZone)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        guard let date = dateFormatter.date(from: str) else {
            return nil
        }
        return date
        
    }
    //MARK:返回字符串时间 出入的Date + 8小时之后的时间
    static func lca_getDate(date:Date,format:String)->String {
        return lca_getDate(date: date, format: format, timeZone: TimeZone.current, local: Locale.autoupdatingCurrent)
    }
    //MARK:根据timeZone和local返回时间字符串
    static func lca_getDate(date:Date,format:String,timeZone:TimeZone,local:Locale)->String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat=format
        dateFormat.locale = local
        dateFormat.timeZone = timeZone
        return dateFormat.string(from: date)
    }
    //MARK:将格林威尼时间转换为本地时间
    func lca_getlocalDate()->Date{
        let zone = TimeZone.current ////获得当前应用程序默认的时区
        let interval = zone.secondsFromGMT(for: Date()) //以秒为单位返回当前应用程序的时间与世界标准时间（格林威尼时间）的时差
        let localeDate = addingTimeInterval(TimeInterval(interval)) //在格林威尼时间的基础上加上时差得到本地时间
        return localeDate
    }
    
    //MARK:返回周几 1 2 3 4 5 6 7 分别表示周一到周日
    static func lca_getWeekday(date:Date)->Int{
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let timeZone = TimeZone.current
        calendar.timeZone = timeZone
        let calendarUnit = Calendar.Component.weekday
        let theComponents = calendar.dateComponents([calendarUnit], from: date)
        let day = theComponents.weekday!
        if day == 1 {
            return 7
        }else {
            return day - 1
        }
    }
    
    //MARK:获取当前时间的时间戳
    func lca_getTimestamp()->String{
        let timeInterval = timeIntervalSince1970
        let timestamp = String(format: "%.f", timeInterval)
        
        return timestamp
    }
    //MARK:通过日期返回时间戳字符串
    static func lca_getTimestamp(dateStr:String,format:String)->String?{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: dateStr) {
            let timeStr = date.lca_getTimestamp()
            return timeStr
        }else {
            return nil
        }
    }
    //MARK:通过时间戳获取日期
    static func lca_getDate(timestamp:String,format:String)->String? {
        
        guard var timestampNum = Double(timestamp) else {
            return nil
        }
        //服务器返回的时间戳一般为13位，而ios时间戳为10位
        if timestamp.count == 13 {
            timestampNum = timestampNum / 1000
        }
        //UTC时间
        let confromTimesp = Date(timeIntervalSince1970:timestampNum)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: confromTimesp)
    }
    //MARK: 返回拼接的日期
    static func lca_date(year:NSInteger,month:NSInteger,day:NSInteger,hour:NSInteger,minute:NSInteger,second:NSInteger)->Date?{
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let systemTimeZone = TimeZone(secondsFromGMT: 0)!
        var dateComps = DateComponents()
        dateComps.calendar = gregorian
        dateComps.year = year
        dateComps.month = month
        dateComps.day = day
        dateComps.timeZone = systemTimeZone
        dateComps.hour = hour
        dateComps.minute = minute
        dateComps.second = second
        return dateComps.date
    }
    //MARK:获取当前的calendar
    static func currentCalendar()->Calendar {
        return Calendar.autoupdatingCurrent
    }
    //MARK:获取某个日期之后n年之后的日期
    func lca_dateByAdding(years:Int)->Date?{
        var dateComponent = DateComponents()
        dateComponent.year = years
        let newDate = Calendar.current.date(byAdding: dateComponent, to: self)
        return newDate
    }
    //MARK:获取某个日期之后n年之前的日期
    func lca_dateBySubtract(years:Int)->Date? {
        return lca_dateByAdding(years:years * -1)
    }
    //MARK:获取某个日期之后n月之后的日期
    func lca_dateByAdding(months:Int)->Date?{
        var dateComponent = DateComponents()
        dateComponent.month = months
        let newDate = Calendar.current.date(byAdding: dateComponent, to: self)
        return newDate
    }
    //MARK:获取某个日期之后n月之前的日期
    func lca_dateBySubtract(months:Int)->Date? {
        return lca_dateByAdding(months:months * -1)
    }
    //MARK:获取某个日期之后n天的日期
    func lca_dateByAdding(days:Int)->Date?{
        var dateComponent = DateComponents()
        dateComponent.day = days
        let newDate = Calendar.current.date(byAdding: dateComponent, to: self)
        return newDate
    }
    //MARK:获取某个日期前days天的日期
    func lca_dateBySubtract(days:Int)->Date? {
        return lca_dateByAdding(days: days * -1)
    }
    //MARK:获取某个日期之后n天的日期
    func lca_dateByAdding(hours:Int)->Date?{
        var dateComponent = DateComponents()
        dateComponent.hour = hours
        let newDate = Calendar.current.date(byAdding: dateComponent, to: self)
        return newDate
    }
    //MARK:获取某个日期前days天的日期
    func lca_dateBySubtract(hours:Int)->Date? {
        return lca_dateByAdding(hours: hours * -1)
    }
    //MARK:获取某个日期之后n天的日期
    func lca_dateByAdding(minutes:Int)->Date?{
        var dateComponent = DateComponents()
        dateComponent.minute = minutes
        let newDate = Calendar.current.date(byAdding: dateComponent, to: self)
        return newDate
    }
    //MARK:获取某个日期前days天的日期
    func lca_dateBySubtract(minutes:Int)->Date? {
        return lca_dateByAdding(minutes: minutes * -1)
    }
    //MARK:明天
    static func dateTomorrow()->Date {
        return Date().lca_dateByAdding(days: 1)!
    }
    //MARK:昨天
    static func dateYesterday()->Date {
        return Date().lca_dateBySubtract(days: -1)!
    }
    //MARK:获取一天开始的时间00:00:00
    func lca_dateAtStartOfDay()->Date? {
        var components = Date.currentCalendar().dateComponents(componentFlags, from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return Date.currentCalendar().date(from: components)
    }
    
    //MARK:获取一天结束的时间:23:59:59
    func lca_dateAtEndOfDay()->Date? {
        var components = Date.currentCalendar().dateComponents(componentFlags, from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return Date.currentCalendar().date(from: components)
    }
    
    //MARK:返回距离当前时间最近的小时
    func lca_nearestHour()->Int?{
        let aTimeInterval = Date.timeIntervalSinceReferenceDate + kMinute * 30
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        let components = Date.currentCalendar().dateComponents(componentFlags, from: newDate)
        
        return components.hour
    }
    //MARK:返回当前时间的小时
    func lca_hour()->Int? {
        let components = Date.currentCalendar().dateComponents(componentFlags, from: self)
        return components.hour
    }
    
    //MARK:比较日期是否相等
    func lca_isEqualToDateIgnoringTime(date:Date)->Bool{
        let components1 = Date.currentCalendar().dateComponents(componentFlags, from: self)
        let components2 = Date.currentCalendar().dateComponents(componentFlags, from: date)
        if components1.year == components2.year,components1.month == components2.month,components1.day == components2.day {
            return true
        }else {
            return false
        }
    }
    //MARK:是否是今天
    func lca_isToday()->Bool {
        return lca_isEqualToDateIgnoringTime(date: Date())
    }
    //MARK:是否是明天
    func lca_isTomorrow()->Bool {
        return lca_isEqualToDateIgnoringTime(date: Date.dateTomorrow())
    }
    //MARK:是否是昨天
    func lca_isYesterday()->Bool {
        return lca_isEqualToDateIgnoringTime(date: Date.dateYesterday())
    }
    
    //MARK:是否是同一周
    func lca_isSameWeek(date:Date)->Bool{
        let components1 = Date.currentCalendar().dateComponents(componentFlags, from: self)
        let components2 = Date.currentCalendar().dateComponents(componentFlags, from: date)
        if components1.weekOfMonth != components2.weekOfMonth {
            return false
        }
        
        return (fabs(timeIntervalSince(date))<kWeek)
    }
    //MARK:是否这周
    func lca_isThisWeek()->Bool {
        return lca_isSameWeek(date: Date())
    }
    //MARK:是否是下周
    func lca_isNextWeek()->Bool {
        let aTimeInterval = Date.timeIntervalSinceReferenceDate + kWeek
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        
        return lca_isSameWeek(date: newDate)
    }
    //MARK:是否是上周
    func lca_isLastWeek()->Bool {
        let aTimeInterval = Date.timeIntervalSinceReferenceDate - kWeek
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        
        return lca_isSameWeek(date: newDate)
        
    }
    //MARK:比较是否是两个相等的月份
    func lca_isSameMonth(date:Date)->Bool {
        let components1 = Date.currentCalendar().dateComponents(componentFlags, from: self)
        let components2 = Date.currentCalendar().dateComponents(componentFlags, from: date)
        if components1.month == components2.month,components1.year == components2.year {
            return true
        }else {
            return false
        }
    }
    //MARK:是否是这个月
    func lca_isThisMonth()->Bool {
        return lca_isSameMonth(date: Date())
    }
    
    //MARK:是否是上个月
    func lca_isLastMonth()->Bool {
        
        return lca_isSameMonth(date: Date().lca_dateBySubtract(months: 1)!)
    }
    //MARK:是否是下个月
    func lca_isNextMonth()->Bool {
        return lca_isSameMonth(date: Date().lca_dateByAdding(months: 1)!)
    }
    //MARK:比较年份
    func lca_isSameYear(date:Date)->Bool {
        let components1 = Date.currentCalendar().dateComponents(componentFlags, from: self)
        let components2 = Date.currentCalendar().dateComponents(componentFlags, from: date)
        if components1.year == components2.year {
            return true
        }else {
            return false
        }
    }
    //MARK:是否是今年
    func lca_isThisYear()->Bool {
        return lca_isSameYear(date: Date())
    }
    //MARK:是否是明年
    func lca_isNextYear()->Bool {
        return lca_isSameYear(date: Date().lca_dateByAdding(years: 1)!)
    }
    //MARK:是否是去年
    func lca_isLastYear()->Bool {
        return lca_isSameYear(date: Date().lca_dateBySubtract(years: -1)!)
    }
    //MARK:早于某个时间
    func lca_isEarlier(date:Date)->Bool {
        return compare(date) == .orderedAscending
    }
    //MARK:晚于某个时间
    func lca_isLater(date:Date)->Bool {
        return compare(date) == .orderedDescending
    }
    //MARK:在未来
    func lca_isInFuture()->Bool {
        return lca_isLater(date: Date())
    }
    //MARK:在过去
    func lca_isInPast()->Bool {
        return lca_isEarlier(date: Date())
    }
    
    //MARK:两个日期相隔的天数
    static func lca_dayInterval(startDate:Date,endDate:Date)->Int? {
        let canlendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let flag = Calendar.Component.day
        let comps = canlendar.dateComponents([flag], from: startDate, to: endDate)
        
        return comps.day
    }
    //MARK:两个日期相隔的时间
    static func lca_getTimeInterval(startTime:String,endTime:String,format:String)->(year:String,month:String,day:String,hour:String,minute:String,second:String)?{
        let canlendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let startDate = dateFormatter.date(from: startTime) else {
            return nil
        }
        guard let endDate = dateFormatter.date(from: endTime) else {
            return nil
        }
        var sets = Set<Calendar.Component>()
        
        let flags = [Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second]
        for vale in flags {
            sets.insert(vale)
        }
        let date = canlendar.dateComponents(sets, from: startDate, to: endDate)
        
        return (year:String(format: "%ld", date.year ?? 0),month:String(format: "%ld", date.month ?? 0),day: String(format: "%ld", date.day ?? 0),hour: String(format: "%ld", date.hour ?? 0),minute: String(format: "%ld", date.minute ?? 0),second: String(format: "%ld", date.second ?? 0))
        
    }
    
}

