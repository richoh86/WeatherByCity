//
//  Extensions.swift
//  WeatherByCity
//
//  Created by richard oh on 2019/08/05.
//  Copyright © 2019 richard oh. All rights reserved.
//

import Foundation

// MARK: - Date Extension 날짜, 시간 변환
extension Date {
    // UTC to Local Time 변환
    public static func UTCToLocal(inputTime: Float, timeZone: Int) -> String {
        let sunriseTimeDate = Date(timeIntervalSince1970: TimeInterval(inputTime))
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "h:mm a"
        dateFormatter1.timeZone = TimeZone(secondsFromGMT: timeZone)
        return dateFormatter1.string(from: sunriseTimeDate)
    }
}
