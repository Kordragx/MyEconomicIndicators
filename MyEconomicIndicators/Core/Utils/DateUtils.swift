//
//  DateUtils.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//


import Foundation

struct DateUtils {
    static func parseAPI(dateString: String) -> Date? {
        ISO8601DateFormatter().date(from: dateString)
    }
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
}
