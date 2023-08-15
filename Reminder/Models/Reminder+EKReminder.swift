//
//  Reminder+EKReminder.swift
//  Reminder
//
//  Created by Nikita on 15/8/23.
//

import Foundation
import EventKit

extension Reminder {
    
    init(with ekReminder: EKReminder) throws {
        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else { throw ReminderError.reminderHasNoDueDate }
        
        id = ekReminder.calendarItemIdentifier
        title = ekReminder.title
        self.dueDate = dueDate
        notes = ekReminder.notes
        isComplete = ekReminder.isCompleted
    }
}
