//
//  TextViewContentView.swift
//  Reminder
//
//  Created by Nikita on 12/8/23.
//

import UIKit

class TextViewContentView: UIView, UIContentView {
    
    // MARK: - struct "Configuration"
    struct Configuration: UIContentConfiguration {
        
        var text: String? = ""
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return TextViewContentView(self)
        }
    }
    
    // MARK: - properties
    let textView = UITextView()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    // MARK: - init
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(textView, height: 200)
        textView.backgroundColor = nil
        textView.delegate = self
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - method
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textView.text = configuration.text
    }
}

// MARK: - extension
extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}

extension TextViewContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let configuration = configuration as? TextViewContentView.Configuration else { return }
        configuration.onChange(textView.text)
    }
}
