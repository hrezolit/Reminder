//
//  ReminderListViewController.swift
//  Reminder
//
//  Created by Nikita on 3/8/23.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    var listStyle: ReminderListStyle = .today
    var headerView: ProgressHeaderView?
    var filterReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }.sorted {
            $0.dueDate > $1.dueDate
        }
    }
    
    var progress: CGFloat {
        let pieceSize = 1.0 / CGFloat(filterReminders.count)
        let progress = filterReminders.reduce(0.0) {
            let piece = $1.isComplete ? pieceSize : 0
            return $0 + piece
        }
        return progress
    }
    
    let listStyleSegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.all.name,
        ReminderListStyle.today.name,
        ReminderListStyle.future.name
    ])
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        // assign the list layout to the collection view layout
        collectionView.collectionViewLayout = listLayout
        
        // cell registration
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // configures and returns a cell for a collection view
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: ProgressHeaderView.elementKind,
                                                                            handler: supplementaryRegistrationHandler)
        dataSource.supplementaryViewProvider = { suplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_ :)))
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton
        
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_ :)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl
        
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .reminderGradientFutureBegin
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBacground()
    }
    
    // MARK: - methods
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filterReminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String,at indexPath: IndexPath) {
        
        guard elementKind == ProgressHeaderView.elementKind,
              let progressView = view as? ProgressHeaderView
        else { return }
        
        progressView.progress = progress
    }
    
    func refreshBacground() {
        collectionView.backgroundView = nil
        let backgroundView = UIView()
        let gradientLayer = CAGradientLayer.gradientLayer(for: listStyle, in: collectionView.frame)
        backgroundView.layer.addSublayer(gradientLayer)
        collectionView.backgroundView = backgroundView
        
    }
    
    func pushDetailViewForReminder(withId id: Reminder.ID) {
        let reminder = reminder(withId: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // new list configuration variable with the grouped appearance
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
        listConfiguration.showsSeparators = false
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) {
            [weak self] _, _, completion in
            self?.deleteReminder(withId: id)
            self?.updateSnapshot()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func supplementaryRegistrationHandler(progressView: ProgressHeaderView,
                                                  elementKind: String,
                                                  indexPath: IndexPath) {
        headerView = progressView
        
    }
}
