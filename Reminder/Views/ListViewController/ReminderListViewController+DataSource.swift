//
//  ReminderListViewController+DataSource.swift
//  Reminder
//
//  Created by Nikita on 5/8/23.
//

import UIKit

extension ReminderListViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    // snapshot represents the state of data at a specific point in time
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    // cell registration and configuration
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: String) {
        let reminder = Reminder.sampleData[indexPath.item]
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration),
            .disclosureIndicator(displayed: .always)
        ]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbol = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbol, withConfiguration: symbolConfiguration)
        let button = UIButton()
        button.setImage(image, for: .normal)
        
        return UICellAccessory.CustomViewConfiguration(customView: button,
                                                       placement: .leading(displayed: .always))
    }
}
