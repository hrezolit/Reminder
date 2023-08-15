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
}
