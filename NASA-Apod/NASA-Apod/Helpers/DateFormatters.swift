//
//  DateFormatter.swift
//  NASA-Apod
//
//  Created by Saurav Kedia on 26/05/21.
//

import UIKit

class DateFormatters: NSObject {
    public static func getDateFrom(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from:date)
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
