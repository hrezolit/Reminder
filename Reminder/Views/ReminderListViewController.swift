//
//  ReminderListViewController.swift
//  Reminder
//
//  Created by Nikita on 3/8/23.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    // snapshot represents the state of data at a specific point in time
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        // assign the list layout to the collection view layout
        collectionView.collectionViewLayout = listLayout
        
        // cell registration
        let cellRegistration = UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            
            let reminder = Reminder.sampleData[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            
            contentConfiguration.text = reminder.title
            cell.contentConfiguration = contentConfiguration
        }
        
        // configures and returns a cell for a collection view
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map { $0.title })
        dataSource.apply(snapshot)
        
        collectionView.dataSource = dataSource
    }
    
    // new list configuration variable with the grouped appearance
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
    }
}
