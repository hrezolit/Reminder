//
//  Date+Reminder.swift
//  Reminder
//
//  Created by Nikita on 4/8/23.
//

import Foundation

// expendint Date class for displaying date and time information for users localy
extension Date {
    
    var dayAndTimeText: String {
        // create a string representation of the time
        let timeText = formatted(date: .omitted, time: .shortened)
        
        if Locale.current.calendar.isDateInToday(self) {
            // custom string presentation of time for today reminders
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            
            return String(format: timeFormat, timeText)
        } else {
            //custom string presentation of time for future reminders or in past
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    
    // if this date is in the current calendar day
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
}
