//
//  Theme.swift
//  iTypist
//
//  Created by Steven Diviney on 07/09/2020.
//  Copyright © 2020 Steven Diviney. All rights reserved.
//

import UIKit

var global_theme: Theme!

protocol Themeable {
    func setTheme()
}

var themeListeners : [Themeable] = []

func loadTheme() {
    let themeIndex = UserDefaults.standard.integer(forKey: "theme")
    global_theme = themes[themeIndex]!
    for component in themeListeners {
        component.setTheme()
    }
}

func registerForTheme(component: Themeable) {
    themeListeners.append(component)
}

class Theme: NSObject {
    let textColor : UIColor
    let backgroundColor : UIColor
    let errorColor : UIColor
    
    init(textColor: UIColor, backgroundColor: UIColor, errorColor: UIColor) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.errorColor = errorColor
    }
    
    func setTheme(view: UIView) {
        view.backgroundColor = self.backgroundColor
        view.subviews.forEach { (view) in
            setTheme(view: view)
        }
    }
}

let themes = [0: solarized, 1: light, 2: dark]

let solarized = Theme(textColor: UIColor(red: 0.67, green: 0.80, blue: 0.81, alpha: 1.00),
                      backgroundColor: UIColor(red: 0.00, green: 0.16, blue: 0.20, alpha: 1.00),
                      errorColor: UIColor(red: 0.83, green: 0.33, blue: 0.04, alpha: 1.00))

let dark = Theme(textColor: UIColor(red: 0.92, green: 0.95, blue: 0.96, alpha: 1.00),
                 backgroundColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00),
                 errorColor: UIColor(red: 0.47, green: 0.12, blue: 0.07, alpha: 1.00))

let light = Theme(textColor: UIColor(red: 0.00, green: 0.00, blue: 0.01, alpha: 1.00),
                  backgroundColor: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00),
                  errorColor: UIColor(red: 1.00, green: 0.34, blue: 0.29, alpha: 1.00))
