//
//  TextFactory.swift
//  iTypist
//
//  Created by Steven Diviney on 07/09/2020.
//  Copyright © 2020 Steven Diviney. All rights reserved.
//

import UIKit

class TextFactory: NSObject {

    let theme: Theme
    
    init(theme: Theme) {
      self.theme = theme
    }
    
    enum TextSize: CGFloat {
        case small = 22
        case normal = 32
    }

    func buildString(text: String, text_size: TextSize = .normal) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: text_size.rawValue)
        let attributes:  [NSAttributedString.Key: Any] =
          [NSAttributedString.Key.font: font,
          NSAttributedString.Key.kern: 5,
          NSAttributedString.Key.foregroundColor: theme.textColor]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        return attributedString
    }
}
