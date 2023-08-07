//
//  UIColor+Today.swift
//  Reminder
//
//  Created by Nikita on 7/8/23.
//

import UIKit

extension UIColor {
    static var reminderDetailCellTint: UIColor {
        UIColor(named: "ReminderDetailCellTint") ?? .tintColor
    }

    static var reminderListCellBackground: UIColor {
        UIColor(named: "ReminderListCellBackground") ?? .secondarySystemBackground
    }

    static var reminderListCellDoneButtonTint: UIColor {
        UIColor(named: "ReminderListCellDoneButtonTint") ?? .tintColor
    }

    static var reminderGradientAllBegin: UIColor {
        UIColor(named: "ReminderGradientAllBegin") ?? .systemFill
    }

    static var reminderGradientAllEnd: UIColor {
        UIColor(named: "ReminderGradientAllEnd") ?? .quaternarySystemFill
    }

    static var reminderGradientFutureBegin: UIColor {
        UIColor(named: "ReminderGradientFutureBegin") ?? .systemFill
    }

    static var reminderGradientFutureEnd: UIColor {
        UIColor(named: "ReminderGradientFutureEnd") ?? .quaternarySystemFill
    }

    static var reminderGradientTodayBegin: UIColor {
        UIColor(named: "ReminderGradientTodayBegin") ?? .systemFill
    }

    static var reminderGradientTodayEnd: UIColor {
        UIColor(named: "ReminderGradientTodayEnd") ?? .quaternarySystemFill
    }

    static var reminderNavigationBackground: UIColor {
        UIColor(named: "ReminderNavigationBackground") ?? .secondarySystemBackground
    }

    static var reminderPrimaryTint: UIColor {
        UIColor(named: "ReminderPrimaryTint") ?? .tintColor
    }

    static var reminderProgressLowerBackground: UIColor {
        UIColor(named: "ReminderProgressLowerBackground") ?? .systemGray
    }

    static var reminderProgressUpperBackground: UIColor {
        UIColor(named: "ReminderProgressUpperBackground") ?? .systemGray6
    }
}

