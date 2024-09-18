import XCTest
@testable import VietnameseLunarDateSwift

final class VietnameseLunarDateSwiftTests: XCTestCase {
    
    var calendar: Calendar!
    
    override func setUp() {
        calendar = Calendar(identifier: .gregorian)
    }
    
    override func tearDown() {
        calendar = nil
    }
    
    func testMidAutumn() throws {
        // Mid-autumn festival in 2024
        let date = calendar.date(from: DateComponents(year: 2024, month: 9, day: 17))!
        let lunarDate = LunarDate(from: date)
        
        XCTAssertEqual(lunarDate.month, 8)
        XCTAssertEqual(lunarDate.day, 15)
        XCTAssertEqual(lunarDate.year, 2024)
    }
    
    func testTetEve() throws {
        // New Year's Eve in 2025
        let date = calendar.date(from: DateComponents(year: 2025, month: 1, day: 28))!
        let lunarDate = LunarDate(from: date)
        
        XCTAssertEqual(lunarDate.month, 12)
        XCTAssertEqual(lunarDate.day, 29)
        XCTAssertEqual(lunarDate.year, 2024)
    }
    
    func testLeapYear() throws {
        // New Year's Eve in 2025
        let date1 = calendar.date(from: DateComponents(year: 2023, month: 3, day: 21))! // Ngày 30/2
        let date2 = calendar.date(from: DateComponents(year: 2023, month: 3, day: 22))! // Ngày 1/2 (nhuận)
        let date3 = calendar.date(from: DateComponents(year: 2023, month: 4, day: 20))! // Ngày 1/3
        let lunarDate1 = LunarDate(from: date1)
        let lunarDate2 = LunarDate(from: date2)
        let lunarDate3 = LunarDate(from: date3)
        
        XCTAssertEqual(lunarDate1.day, 30)
        XCTAssertEqual(lunarDate1.month, 2)
        XCTAssertEqual(lunarDate1.isLeap, false)
        
        XCTAssertEqual(lunarDate2.day, 1)
        XCTAssertEqual(lunarDate2.month, 2)
        XCTAssertEqual(lunarDate2.isLeap, true)
        
        XCTAssertEqual(lunarDate3.month, 3)
        XCTAssertEqual(lunarDate3.isLeap, false)
    }
    
    func testJulius() throws {
        let earlyDate = calendar.date(from: DateComponents(year: 1582, month: 10, day: 04))!
        XCTAssertEqual(earlyDate.toJuliusDays(), 2299160)
        let lateDate = calendar.date(from: DateComponents(year: 1582, month: 10, day: 15))!
        XCTAssertEqual(lateDate.toJuliusDays(), 2299161)
    }
    
    func testCanChi() throws {
        // Ngay 17/09/2024 Duong -> 15/08/2024 Am lich
        let date = calendar.date(from: DateComponents(year: 2024, month: 9, day: 17))!
        let lunarDate = date.lunarDate
        let info = lunarDate.info
        
        XCTAssertEqual(info.date, CanChi(.giap, .than)) // Giap than
        XCTAssertEqual(info.month, CanChi(.quy, .dau)) // Quy Dau
        XCTAssertEqual(info.year, CanChi(.giap, .thin)) // Giap Thin
    }
}
