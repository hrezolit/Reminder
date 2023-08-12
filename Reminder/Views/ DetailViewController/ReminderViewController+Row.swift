//
//  File.swift
//  Reminder
//
//  Created by Nikita on 8/8/23.
//

import UIKit

extension ReminderViewController {
    enum Row: Hashable {
        case header(String)
        case notes
        case date
        case time
        case title
        case editableDate(Date)
        case editableText(String?)
        
        var imageName: String? {
            switch self {
            case .date:
                return "calendar.circle"
            case .notes:
                return "square.and.pencile"
            case .time:
                return "clock"
            default:
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
