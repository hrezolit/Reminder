//
//  CAGradientLayer+ListStyle.swift
//  Reminder
//
//  Created by Nikita on 14/8/23.
//

import UIKit

extension CAGradientLayer {
    
    static func gradientLayer(for style: ReminderListStyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors(for: style)
        layer.frame = frame
        
        return layer
    }
    
    private static func colors(for style: ReminderListStyle) -> [CGColor] {
        
        let begingColor: UIColor
        let endColor: UIColor
        
        switch style {
        case .all:
            begingColor = .reminderGradientAllBegin
            endColor = .reminderGradientAllEnd
        case .today:
            begingColor = .reminderGradientTodayBegin
            endColor = .reminderGradientTodayEnd
        case .future:
            begingColor = .reminderGradientFutureBegin
            endColor = .reminderGradientFutureEnd
        }
        
        return [begingColor.cgColor, endColor.cgColor]
    }
}

