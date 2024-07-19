//
//  Fonts+Extensions.swift
import SwiftUI

extension Font {

    static var todoLargeTitle: Font {
        .largeTitle
    }

    static var todoTitle: Font {
        .title2
    }

    static var todoHeadline: Font {
        .headline
    }

    static var todoBody: Font {
        .body
    }

    static var todoSubhead: Font {
        .subheadline
    }

    static var todoFootnote: Font {
        .footnote.weight(.semibold)
    }

}

extension Date {

    static var nextDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: .now)!.stripTime()
    }

    var dayAndMonthString: String {
        formatted(.dateTime.day(.twoDigits).month(.abbreviated))
    }

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}
