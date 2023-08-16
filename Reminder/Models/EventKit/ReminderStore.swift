//
//  ReminderStore.swift
//  Reminder
//
//  Created by Nikita on 15/8/23.
//

import Foundation
import EventKit

final class ReminderStroe {
    
    static let shared = ReminderStroe()
    
    private let ekStore = EKEventStore()
    
    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }
    
    func requestAccess() async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        
        switch status {
        case .notDetermined:
            let accessGranted = try await ekStore.requestAccess(to: .reminder)
            guard accessGranted else { throw ReminderError.accesDenied}
        case .restricted:
            throw ReminderError.accessRestricted
        case .denied:
            throw ReminderError.accesDenied
        case .authorized:
            return
        @unknown default:
            throw ReminderError.unknown
        }
    }
    
    func readAll() async throws -> [Reminder] {
        guard isAvailable else { throw ReminderError.accesDenied }
        
        let predicate = ekStore.predicateForReminders(in: nil)
        let ekReminders = try await ekStore.reminders(matching: predicate)
        let reminders: [Reminder] = try ekReminders.compactMap { ekReminder in
            do {
                return try Reminder(with: ekReminder)
            } catch ReminderError.reminderHasNoDueDate {
                return nil
            }
        }
        return reminders
    }
    
    @discardableResult
    func save(_ reminder: Reminder) throws -> Reminder.ID {
        
        guard isAvailable else { throw ReminderError.accesDenied }
        
        let ekReminder: EKReminder
        do {
            ekReminder = try read(with: reminder.id)
        } catch {
            ekReminder = EKReminder(eventStore: ekStore)
        }
        
        ekReminder.update(using: reminder, in: ekStore)
        try ekStore.save(ekReminder, commit: true)
        
        return ekReminder.calendarItemIdentifier
    }
    
    private func read(with id: Reminder.ID) throws -> EKReminder {
        guard
            let ekReminder = ekStore.calendarItem(withIdentifier: id) as? EKReminder
        else { throw ReminderError.failedReadingCalendarItem }
        
        return ekReminder
    }
}
