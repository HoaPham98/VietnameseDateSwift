//
//  File.swift
//  
//
//  Created by Hoa Pham on 17/9/24.
//

import Foundation

public extension LunarDate {
    struct Info {
        public var date: CanChi
        public var month: CanChi
        public var year: CanChi
    }
    
    var info: Info {
        let jd = solarDate.toJuliusDays()
        let ngay = CanChi(Can(rawValue: (jd + 3) % 10)!, Chi(rawValue: (jd + 1) % 12 + 1)!)
        let thang = CanChi(Can(rawValue: (year * 12 + month - 3) % 10)!, Chi(rawValue: (month + 1) % 12 + 1)!)
        let nam = CanChi(Can(rawValue: year % 10)!, Chi(rawValue: (year + 8) % 12 + 1)!)
        
        return Info(date: ngay, month: thang, year: nam)
    }
}
