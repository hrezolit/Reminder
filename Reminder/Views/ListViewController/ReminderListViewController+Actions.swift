//
//  ReminderListViewController+Actions.swift
//  Reminder
//
//  Created by Nikita on 6/8/23.
//

import UIKit

extension ReminderListViewController {
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(withId: id)
    }
}
