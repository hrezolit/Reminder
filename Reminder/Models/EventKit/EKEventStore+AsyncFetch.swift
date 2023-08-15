//
//  EKEventStore+AsyncFetch.swift
//  Reminder
//
//  Created by Nikita on 15/8/23.
//

import Foundation
import EventKit

extension EKEventStore {
    func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        
        try await withCheckedThrowingContinuation { continuation in
            fetchReminders(matching: predicate) { reminders in
                if let reminders {
                    continuation.resume(returning: reminders)
                } else {
                    continuation.resume(throwing: ReminderError.failedReadingReminders)
                }
                
            }
        }
    }
}
