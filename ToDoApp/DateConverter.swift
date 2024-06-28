//
//  DateConverter.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 29.06.2024.
//

import Foundation

class DateConverter {
    
    func convertDateToStringDayMonth(date: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "d MMMM"
        guard let date = date else { return nil}
        return dateFormatter.string(from: date)
    }
    
    func convertDateToStringDayMonthYear(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}
