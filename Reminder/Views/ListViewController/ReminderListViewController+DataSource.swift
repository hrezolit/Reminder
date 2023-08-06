//
//  ReminderListViewController+DataSource.swift
//  Reminder
//
//  Created by Nikita on 5/8/23.
//

import UIKit

extension ReminderListViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    // snapshot represents the state of data at a specific point in time
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    // method for updating snapshot
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        
        // initializing snapshot
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map { $0.id })
        snapshot.appendItems(reminders.map { $0.id})
        
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
            dataSource.apply(snapshot)
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
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration),
            .disclosureIndicator(displayed: .always)
        ]
        
        // background config
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    // accepts a reminder identifier and returns the corresponding reminder from the reminders array
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withId: id)
        
        return reminders[index]
    }
    
    // update the cell registration handler to use the new method to retrieve the reminder with the provided id
    func updateReminder(_ reminder: Reminder) {
        let index = reminders.indexOfReminder(withId: reminder.id)
        reminders[index] = reminder
    }
    
    // fetchin a reminder from model
    func completeReminder(withId id: Reminder.ID) {
        var remider = reminder(withId: id)
        remider.isComplete.toggle()
        
        updateReminder(remider)
        updateSnapshot(reloading: [id])
    }
    
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
