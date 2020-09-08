//
//  Theme.swift
//  iTypist
//
//  Created by Steven Diviney on 07/09/2020.
//  Copyright © 2020 Steven Diviney. All rights reserved.
//

import UIKit

class Theme: NSObject {
    let textColor : UIColor
    let backgroundColor : UIColor
    let errorColor : UIColor
    
    init(textColor: UIColor, backgroundColor: UIColor, errorColor: UIColor) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.errorColor = errorColor
    }
}

let solarized = Theme(textColor: UIColor(red: 0.67, green: 0.80, blue: 0.81, alpha: 1.00),
                      backgroundColor: UIColor(red: 0.00, green: 0.16, blue: 0.20, alpha: 1.00),
                      errorColor: UIColor(red: 0.83, green: 0.33, blue: 0.04, alpha: 1.00))
