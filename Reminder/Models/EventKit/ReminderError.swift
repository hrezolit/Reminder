//
//  ReminderError.swift
//  Reminder
//
//  Created by Nikita on 15/8/23.
//

import Foundation

enum ReminderError: LocalizedError {
    
    case failedReadingReminders
    case reminderHasNoDueDate
    case accesDenied
    
    var errorDescription: String? {
        switch self {
        case .failedReadingReminders:
            return NSLocalizedString("Failed to read reminders.", comment: "failed reading reminders error description")
        case .reminderHasNoDueDate:
            return NSLocalizedString("A reminder has no due date.", comment: "reminder has no due date error description")
        case .accesDenied:
            return NSLocalizedString("The app doesn't have permission to read reminders.", comment: "access denied error description")
        }
    }
}
