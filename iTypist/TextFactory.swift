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
    let font_size : CGFloat = 32

    init(theme: Theme) {
      self.theme = theme
    }

    func buildString(text: String) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: font_size)
        let attributes:  [NSAttributedString.Key: Any] =
          [NSAttributedString.Key.font: font,
          NSAttributedString.Key.kern: 5,
          NSAttributedString.Key.foregroundColor: theme.textColor]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        return attributedString
    }
}
