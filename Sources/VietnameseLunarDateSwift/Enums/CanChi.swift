//
//  CanChi.swift
//
//
//  Created by Hoa Pham on 17/9/24.
//

import Foundation

// Thiên can
public enum Can: Int {
    case canh, tan, nham , quy, giap, at, binh, dinh, mau, ky
}

// Địa chi
public enum Chi : Int {
    case ty = 1
    case suu, dan, ma, thin, ti, ngo, mui, than, dau, tuat, hoi
}

public struct CanChi: Equatable {
    public let can: Can
    public let chi: Chi
    
    init(_ can: Can, _ chi: Chi) {
        self.can = can
        self.chi = chi
    }
}

