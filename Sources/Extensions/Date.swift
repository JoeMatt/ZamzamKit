//
//  NSDateExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Date {
    
    /// Determines if date is in the past.
    var isPast: Bool {
        return self < Date()
    }
    
    /// Determines if date is in the future.
    var isFuture: Bool {
        return self > Date()
    }
    
    /// Determines if date is in today's date.
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Determines if date is in yesterday's date.
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Determines if date is in tomorrow's date.
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
	
	/// Determines if date is within a weekend period.
	var isWeekend: Bool {
		return Calendar.current.isDateInWeekend(self)
	}
    
    /// Determines if date is within a weekday period.
    var isWeekday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
    
    /// Determine if a date is between two other dates.
    /// Dates do not have to be in sequential order.
    ///
    /// - Parameters:
    ///   - date1: first date to compare to.
    ///   - date2: second date to compare to.
    /// - Returns: true if the date is between the two given dates.
    func isBetween(_ date1: Date, _ date2: Date) -> Bool {
        // https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/Extensions/Foundation/DateExtensions.swift
        return date1.compare(self).rawValue * compare(date2).rawValue > 0
    }
}

// MARK: - String helpers

public extension Date {
    
    /// Gets the beginning of the day.
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Gets the end of the day.
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    /// Gets the beginning of the month.
    var startOfMonth: Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: startOfDay)
        )!
    }
    
    /// Gets the end of the month.
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}

// MARK: - String helpers

public extension Date {
    
    init?(fromString: String, dateFormat: String = "yyyy/MM/dd HH:mm", timeZone: TimeZone? = nil) {
        guard !fromString.isEmpty,
            let date = DateFormatter(dateFormat: dateFormat, timeZone: timeZone).date(from: fromString)
            else { return nil }
        
        self.init(timeInterval: 0, since: date)
    }

    /// Returns a string representation of a given date formatted using the receiver’s current settings.
    ///
    /// - Parameter format: The date format string used by the receiver.
    /// - Returns: The string representation of the given date.
    func string(format: String, timeZone: TimeZone? = nil) -> String {
        return DateFormatter(dateFormat: format, timeZone: timeZone).string(from: self)
    }
    
    /// Fixed-format for the date without time, i.e. 2017-05-15.
    ///
    /// - Parameter timeZone: Time zone to determine day boundries of the date.
    /// - Returns: The formatted date string.
    func shortString(with timeZone: TimeZone? = nil) -> String {
        return DateFormatter(dateFormat: "yyyy-MM-dd", timeZone: timeZone).with {
            $0.locale = .posix
        }.string(from: self)
    }
    
    /// Formats time interval for display timer.
    ///
    /// - Parameter date: The date to countdown from.
    /// - Returns: The formatted timer as hh:mm:ss.
    func timerString(from date: Date = Date()) -> String {
        let seconds = Int(timeIntervalSince(date))
        let prefix = seconds < 0 ? "+" : ""
        let hr = abs(seconds / 3600)
        let min = abs(seconds / 60 % 60)
        let sec = abs(seconds % 60)
        return .localizedStringWithFormat("%@%02i:%02i:%02i", prefix, hr, min, sec)
    }
}

// MARK: - Calculation helpers

public extension Date {

    /// Add years to date.
    ///
    /// - Parameters:
    ///   - years: Number of years to add.
    ///   - calendar: The calendar to use for the computation.
    /// - Returns: The date result after the addition of years. Defaults to the current calendar.
    func increment(years: Int, calendar: Calendar = .current) -> Date {
        guard years != 0 else { return self }
        return calendar.date(
            byAdding: .year,
            value: years,
            to: self
        )!
    }

    /// Add months to date.
    ///
    /// - Parameters:
    ///   - months: Number of months to add.
    ///   - calendar: The calendar to use for the computation.
    /// - Returns: The date result after the addition of months. Defaults to the current calendar.
    func increment(months: Int, calendar: Calendar = .current) -> Date {
        guard months != 0 else { return self }
        return calendar.date(
            byAdding: .month,
            value: months,
            to: self
        )!
    }

    /// Add days to date.
    ///
    /// - Parameters:
    ///   - days: Number of days to add.
    ///   - calendar: The calendar to use for the computation.
    /// - Returns: The date result after the addition of days. Defaults to the current calendar.
    func increment(days: Int, calendar: Calendar = .current) -> Date {
        guard days != 0 else { return self }
        return calendar.date(
            byAdding: .day,
            value: days,
            to: self
        )!
    }
    
    /// Add minutes to date.
    ///
    /// - Parameters:
    ///   - minutes: Number of minutes to add.
    ///   - calendar: The calendar to use for the computation.
    /// - Returns: The date result after the addition of minutes. Defaults to the current calendar.
    func increment(minutes: Int, calendar: Calendar = .current) -> Date {
        guard minutes != 0 else { return self }
        return calendar.date(
            byAdding: .minute,
            value: minutes,
            to: self
        )!
    }
    
    /// Ensures the date is always in the future.
    ///
    /// - Parameters:
    ///   - calendar: The calendar to use for the computation.
    /// - Returns: No change if in the future or adds exactly one day
    func incrementDayIfPast(calendar: Calendar = .current) -> Date {
        return isPast ? increment(days: 1, calendar: calendar) : self
    }
    
    /// Specifies if the date is beyond the time window.
    ///
    /// - Parameters:
    ///   - seconds: Time window the date is considered valid.
    ///   - date: Date to use as a reference.
    /// - Returns: Has the time elapsed the time window.
    func hasElapsed(seconds: Int, from date: Date = Date()) -> Bool {
        return date.timeIntervalSince(self).seconds > seconds
    }
    
    /// Gets the decimal representation of the time.
    var timeToDecimal: Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self)
        let hour = components.hour
        let minutes = components.minute
        return Double(hour!) + (Double(minutes!) / 60.0)
    }
}

// MARK: - Time zone helpers

public extension Date {

    /// Moves the date to the specified time zone.
    ///
    /// - Parameter timeZone: The target time zone.
    /// - Returns: The shifted date using the time zone.
    func shift(to timeZone: TimeZone) -> Date {
        return timeZone.isCurrent ? self : {
            let calendar = Calendar.current
            
            var dateComponents = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: self
            )
            
            // Shift from GMT using difference of current and specified time zone
            dateComponents.second = -timeZone.offsetFromCurrent

            return calendar.date(from: dateComponents) ?? self
        }()
    }
}

// MARK: - Islamic calendar

public extension Date {

    // Cache Islamic calendar for reuse
    // https://www.staff.science.uu.nl/~gent0113/islam/ummalqura.htm
    // http://tabsir.net/?p=621#more-621
    static let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)

    /// Returns a string representation of a given date formatted to hijri date.
    ///
    /// - Parameters:
    ///   - components: The components of the date to format.
    ///   - format: The date format string used by the receiver.
    ///   - offSet: The number of days to offset the hijri date.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar of the receiver.
    /// - Returns: A string representation of a given date formatted to hijri date.
    func hijriString(
        components: Set<Calendar.Component> = Calendar.Component.date,
        format: String? = nil,
        offSet: Int = 0,
        timeZone: TimeZone? = nil,
        calendar: Calendar = Date.islamicCalendar) -> String
    {
        var calendar = calendar
        if let timeZone = timeZone { calendar.timeZone = timeZone }
        
        let formatter = DateFormatter().with {
            $0.calendar = calendar
            $0.timeZone = calendar.timeZone
            if let f = format { $0.dateFormat = f }
            else { $0.dateStyle = .long }
        }
        
        let date = calendar.date(
            from: hijri(
                components: components,
                offSet: offSet,
                timeZone: timeZone,
                calendar: calendar
            )
        )!
        
        return formatter.string(from: date)
    }
    
    /// Returns the date components of the hijri date.
    ///
    /// - Parameters:
    ///   - components: The components of the date to format.
    ///   - offSet: The number of days to offset the hijri date.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar of the receiver.
    /// - Returns: The date components of the hijri date.
    func hijri(
        components: Set<Calendar.Component> = Calendar.Component.date,
        offSet: Int = 0,
        timeZone: TimeZone? = nil,
        calendar: Calendar = Date.islamicCalendar) -> DateComponents
    {
        var calendar = calendar
        
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let date = increment(days: offSet, calendar: calendar)
        return calendar.dateComponents(components, from: date)
    }
    
    /// Determines if the date falls within Ramadan.
    ///
    /// - Parameters:
    ///   - offSet: The number of days to offset the hijri date.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar of the receiver.
    /// - Returns: True if the date is within Ramadan; false otherwise.
    func isRamadan(offSet: Int = 0, timeZone: TimeZone? = nil, calendar: Calendar = Date.islamicCalendar) -> Bool {
        return hijri(offSet: offSet, timeZone: timeZone, calendar: calendar).month == 9
    }
    
    /// Determines if the date if Friday / Jumuah.
    var isJumuah: Bool {
        return Calendar.current.dateComponents([.weekday], from: self).weekday == 6
    }
}
