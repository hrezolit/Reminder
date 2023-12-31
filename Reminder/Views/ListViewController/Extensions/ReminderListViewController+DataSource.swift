//
//  ReminderListViewController+DataSource.swift
//  Reminder
//
//  Created by Nikita on 5/8/23.
//

import UIKit

extension ReminderListViewController {
    
    // MARK: - typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    // snapshot represents the state of data at a specific point in time
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    // MARK: - properties
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder complited value")
    }
    
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not comleted", comment: "Reminder not completed value")
    }
    
    private var reminderStore: ReminderStroe { ReminderStroe.shared }
    
    // MARK: - public methods
    
    // method for updating snapshot
    func updateSnapshot(reloading idsThatChange: [Reminder.ID] = []) {
        
        let ids = idsThatChange.filter { id in
            filterReminders.contains(where: { $0.id == id })
        }
        
        // initializing snapshot
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filterReminders.map { $0.id })
        
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        
        dataSource.apply(snapshot)
        headerView?.progress = progress
    }
    
    // cell registration and configuration
    func cellRegistrationHandler(cell: UICollectionViewListCell,
                                 indexPath: IndexPath,
                                 id: Reminder.ID) {
        
        let reminder = reminder(withId: id)
        
        // cell config
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        // done button common config
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .reminderListCellDoneButtonTint
        cell.accessibilityCustomActions = [
            doneButtonAccessibilityAction(for: reminder)
        ]
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration),
            .disclosureIndicator(displayed: .always)
        ]
        
        // background config
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .reminderListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    // accepts a reminder identifier and returns the corresponding reminder from the reminders array
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withId: id)
        
        return reminders[index]
    }
    
    // update the cell registration handler to use the new method to retrieve the reminder with the provided id
    func updateReminder(_ reminder: Reminder) {
        do {
            try reminderStore.save(reminder)
            let index = reminders.indexOfReminder(withId: reminder.id)
            reminders[index] = reminder
        } catch ReminderError.accesDenied {
            
        } catch {
            showError(error)
        }
    }
    
    // fetchin a reminder from model
    func completeReminder(withId id: Reminder.ID) {
        var remider = reminder(withId: id)
        remider.isComplete.toggle()
        updateReminder(remider)
        updateSnapshot(reloading: [id])
    }
    
    func addReminder(_ reminder: Reminder) {
        var reminder = reminder
        do {
            let idFromStore = try reminderStore.save(reminder)
            reminder.id = idFromStore
            reminders.append(reminder)
        } catch ReminderError.accesDenied {
            
        } catch {
            showError(error)
        }
    }
    
    func deleteReminder(withId id: Reminder.ID) {
        do {
            try reminderStore.remove(with: id)
            let index = reminders.indexOfReminder(withId: id)
            reminders.remove(at: index)
        } catch ReminderError.accesDenied {
            
        } catch {
            showError(error)
        }
    }
    
    func reminderStoreChanged() {
        Task {
            reminders = try await reminderStore.readAll()
            updateSnapshot()
        }
    }
    
    func prepareReminderStore() {
        Task {
            do {
                try await reminderStore.requestAccess()
                reminders = try await reminderStore.readAll()
                NotificationCenter.default.addObserver(self, selector: #selector(eventStoreChanged(_ :)), name: .EKEventStoreChanged, object: nil)
            } catch ReminderError.accesDenied, ReminderError.accessRestricted {
                
                #if DEBUG
                reminders = Reminder.sampleData
                #endif
            } catch {
                showError(error)
            }
            updateSnapshot()
        }
    }
    
    // preparing for VoiceOver accessibility
    func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(withId: reminder.id)
            
            return true
        }
        return action
    }
    
    // MARK: - private methods
    
    // done button custom config
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbol = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbol, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_ :)), for: .touchUpInside)
        button.id = reminder.id
        button.setImage(image, for: .normal)
        
        return UICellAccessory.CustomViewConfiguration(customView: button,
                                                       placement: .leading(displayed: .always))
    }
}
