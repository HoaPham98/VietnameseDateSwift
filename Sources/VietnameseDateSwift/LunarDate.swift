// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public typealias SolarDate = Date

public struct LunarDate {
    public var day: Int
    public var month: Int
    public var year: Int
    var leap: Bool
    var solarDate: SolarDate!
    
    init(day: Int, month: Int, year: Int, leap: Bool) {
        self.day = day
        self.month = month
        self.year = year
        self.leap = leap
    }
    
    public var isLeap: Bool {
        return leap
    }
}

extension LunarDate {
    public init(from solarDate: SolarDate) {
        self.init(day: 0, month: 0, year: 0, leap: false)
        let timeZone = 7
        let dayNumber = solarDate.toJuliusDays()
        let k = Int(floor(((Double(dayNumber) - 2415021.076998695) / 29.530588853)))
        var monthStart = getNewMoonDay(nth: k+1, timeZone: timeZone)
        if (monthStart > dayNumber) {
            monthStart = getNewMoonDay(nth: k, timeZone: timeZone)
        }
        
        let dateComponents = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: solarDate)
        let solarYear = dateComponents.year ?? 0
        var lunarYear = 0
        
        var a11 = self.getLunarMonth11(year: solarYear, timeZone: timeZone)
        var b11 = a11
        if (a11 >= monthStart) {
            lunarYear = solarYear
            a11 = self.getLunarMonth11(year: solarYear-1, timeZone: timeZone)
        } else {
            lunarYear = solarYear+1
            b11 = self.getLunarMonth11(year: solarYear+1, timeZone: timeZone)
        }
        let lunarDay = dayNumber-monthStart+1
        let diff = Int(floor(((Double(monthStart) - Double(a11))/29)))
        var lunarLeap = false
        var lunarMonth = diff+11
        if (b11 - a11 > 365) {
            let leapMonthDiff = self.getLeapMonthOffset(a11: a11, timeZone: timeZone)
            if (diff >= leapMonthDiff) {
                lunarMonth = diff + 10
                if (diff == leapMonthDiff) {
                    lunarLeap = true
                }
            }
        }
        if (lunarMonth > 12) {
            lunarMonth = lunarMonth - 12;
        }
        if (lunarMonth >= 11 && diff < 4) {
            lunarYear -= 1;
        }
        
        self.day = lunarDay
        self.month = lunarMonth
        self.year = lunarYear
        self.leap = lunarLeap
        self.solarDate = solarDate
    }
    
    
    private func getNewMoonDay(nth day: Int, timeZone: Int = 7) -> Int {
        let k = Double(day)
        let t: Double = Double(k) / 1236.85 // Time in Julian centuries from 1900 January 0.5
        let tt: Double = t * t
        let ttt: Double = tt * t
        let dr: Double = Double.pi / 180.0
        var jd1: Double = 2415020.75933 + 29.53058868 * k + 0.0001178 * tt - 0.000000155 * ttt
        jd1 = jd1 + 0.00033 * sin((166.56 + 132.87 * t - 0.009173 * tt) * dr) // Mean new moon
        let m: Double = 359.2242 + 29.10535608 * k - 0.0000333 * tt - 0.00000347 * ttt; // Sun's mean anomaly
        let mpr: Double = 306.0253 + 385.81691806 * k + 0.0107306 * tt + 0.00001236 * ttt; // Moon's mean anomaly
        let f: Double = 21.2964 + 390.67050646 * k - 0.0016528 * tt - 0.00000239 * ttt; // Moon's argument of latitude
        var c1: Double = (0.1734 - 0.000393 * t) * sin(m * dr) + 0.0021 * sin(2.0 * dr * m)
        c1 = c1 - 0.4068 * sin(mpr * dr) + 0.0161 * sin(dr * 2.0 * mpr)
        c1 = c1 - 0.0004 * sin(dr * 3.0 * mpr)
        c1 = c1 + 0.0104 * sin(dr * 2.0 * f) - 0.0051 * sin(dr * (m + mpr))
        c1 = c1 - 0.0074 * sin(dr * (m - mpr)) + 0.0004 * sin(dr * (2.0 * f + m))
        c1 = c1 - 0.0004 * sin(dr * (2.0 * f - m)) - 0.0006 * sin(dr * (2.0 * f + mpr))
        c1 = c1 + 0.0010 * sin(dr * (2.0 * f - mpr)) + 0.0005 * sin(dr * (2.0 * mpr + m))
        var deltaT: Double = 0.0
        if t < -11.0 {
            deltaT = 0.001 + 0.000839 * t + 0.0002261 * tt - 0.00000845 * ttt - 0.000000081 * t * ttt
        } else {
            deltaT = -0.000278 + 0.000265 * t + 0.000262 * tt
        }
        let newJd: Double = jd1 + c1 - deltaT
        return Int(floor(newJd + 0.5 + Double(timeZone)/24.0))
    }
    
    private func getSunLongitude(jd: Int, timeZone: Int = 7) -> Int {
        let t: Double = (Double(jd) - 2451545.5 - Double(timeZone) / 24.0) / 36525.0
        let tt = t * t
        let dr = Double.pi / 180.0
        let m = 357.52910 + 35999.05030 * t - 0.0001559 * tt - 0.00000048 * t * tt
        let l0 = 280.46645 + 36000.76983 * t + 0.0003032 * tt
        var dl = (1.914600 - 0.004817 * t - 0.000014 * tt) * sin(dr * m)
        dl = dl + (0.019993 - 0.000101 * t) * sin(dr * 2.0 * m) + 0.000290 * sin(dr * 3.0 * m)
        var l = l0 + dl
        l = l * dr
        l = l - .pi * 2.0 * floor(l / (.pi * 2.0))
        return Int(floor(l / .pi * 6.0))
    }
    
    private func getLunarMonth11(year: Int, timeZone: Int = 7) -> Int {
        var dateComponents = DateComponents()
        dateComponents.day = 31
        dateComponents.month = 12
        dateComponents.year = year
        let date = Calendar(identifier: .gregorian).date(from: dateComponents)!
        let off = Double(date.toJuliusDays()) - 2415021.0
        let k = Int(floor((Double(off) / 29.530588853)))
        var nm = self.getNewMoonDay(nth: k, timeZone: timeZone)
        let sunLong = self.getSunLongitude(jd: nm, timeZone: timeZone) // sun longitude at local midnight
        if (sunLong >= 9) {
            nm = self.getNewMoonDay(nth: k-1, timeZone: timeZone)
        }
        return nm
    }
    
    private func getLeapMonthOffset(a11: Int, timeZone: Int = 7) -> Int {
        let k = Int(floor(((Double(a11) - 2415021.076998695) / 29.530588853 + 0.5)))
        var last = 0
        var i = 1 // We start with the month following lunar month 11
        var arc = self.getSunLongitude(jd: self.getNewMoonDay(nth: k+1, timeZone: timeZone), timeZone: timeZone)
        repeat {
            last = arc
            i += 1
            arc = self.getSunLongitude(jd: self.getNewMoonDay(nth: k+i, timeZone: timeZone), timeZone: timeZone)
        } while (arc != last && i < 14)
        return i-1;
    }
}

extension Date {
    func toJuliusDays() -> Int {
        let dateComponents = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: self)
        guard let day = dateComponents.day, let month = dateComponents.month, let year = dateComponents.year else {
            fatalError()
        }
        
        let a = Int(floor(Double(((14 - month)/12))))
        let y = year + 4800 - a
        let m = month + 12*a - 3
        
        var jd = Int(day + (153*m+2)/5 + 365*y + y/4 - y/100 + y/400 - 32045)
        if (jd < 2299161) {
            jd = Int(day + (153*m+2)/5 + 365*y + y/4 - 32083)
        }
        return jd
    }
}
