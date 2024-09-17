# VietnameseLunarDateSwift

![GitHub release (release name instead of tag name)](https://img.shields.io/github/v/release/HoaPham98/VietnameseLunarDateSwift?include_prereleases&label=version)

Library for convert a day to Vietnamese lunar day. The library use Hồ Ngọc Đức's algorimth. Go to the link bellow for more detail http://www.informatik.uni-leipzig.de/~duc/amlich/

## Features

- ✅ Convert from Gregorian Calendar to Vietnamese Lunar Date
- ✅ Check leap month
- ✅ Get Thiên Can (Heavenly Stems) and Địa Chi (Earthly Branches) for day, month and year
- 🎯 String description
- 🎯 Get Zodiac hours

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code.

You can add Telegraph to your project by choosing the File - Swift Packages - Add Package Dependency option. Use the repository url as specified below and select the version you want to use.

Or you can manually add a `Package.swift` file to your project with:

```swift
dependencies: [
    .package(url: "https://github.com/HoaPham98/VietnameseLunarDateSwift.git")
]
```

### Usage

Convert date from Gregorian Calendar to Vietnamese Lunar Date

```swift
import VietnameseLunarDateSwift
....

let date = Date() // 17/09/2024
let lunarDate = LunarDate(from: date)
// or
let newDate = date.lunarDate // 15/08/2024
```

Check if this date is in leap month

```swift
import VietnameseLunarDateSwift
....

let date = calendar.date(from: DateComponents(year: 2023, month: 3, day: 22))! // 01/02/2023 (leap month)
let lunarDate = date.lunarDate

print(lunarDate.day) // 1
print(lunarDate.month) // 2
print(lunarDate.isLeap) // true
```

Get info
```swift
import VietnameseLunarDateSwift
....

et date = Date() // 17/09/2024
let lunarDate = date.lunarDate // 15/08/2024

let info = date.info
// date: Giap than
// month: Quy Dau
// year: Giap Thin
```

## TODO
- 🎯 String description
- 🎯 Get Zodiac hours
- 🎯 Support Cocoapods