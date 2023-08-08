//
//  File.swift
//  Reminder
//
//  Created by Nikita on 8/8/23.
//

import UIKit

extension ReminderViewController {
    enum Row: Hashable {
        case notes
        case date
        case time
        case title
        
        var imageName: String? {
            switch self {
            case .date:
                return "calendar.circle"
            case .notes:
                return "square.and.pencile"
            case .time:
                return "clock"
            case .title:
                return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .title:
                return .headline
            default:
                return .subheadline
            }
        }
    }
}