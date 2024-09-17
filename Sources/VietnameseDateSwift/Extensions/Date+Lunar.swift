//
//  Date+Lunar.swift
//  
//
//  Created by Hoa Pham on 17/9/24.
//

import Foundation

public extension Date {
    var lunarDate: LunarDate {
        return LunarDate(from: self)
    }
}
