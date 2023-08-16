//
//  DatePickerContentView.swift
//  Reminder
//
//  Created by Nikita on 12/8/23.
//

import UIKit

class DatePickerContentView: UIView, UIContentView {
    
    // MARK: - struct "Configuration"
    struct Configuration: UIContentConfiguration {
        
        var date: Date = .now
        var onChange: (Date) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return DatePickerContentView(self)
        }
    }
    
    // MARK: - properties
    let datePicker = UIDatePicker()
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    // MARK: - init
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(datePicker)
        datePicker.addTarget(self, action: #selector(didChange(_ :)), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .inline
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - init
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        datePicker.date = configuration.date
    }
    
    @objc private func didChange(_ sender: UIDatePicker) {
        guard let configuration = configuration as? DatePickerContentView.Configuration else { return }
        configuration.onChange(sender.date)
    }
}

// MARK: - extension
extension UICollectionViewListCell {
    
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
