//
//  InfoController.swift
//  iTypist
//
//  Created by Steven Diviney on 20/09/2020.
//  Copyright © 2020 Steven Diviney. All rights reserved.
//

import UIKit

class InfoController : UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        let themeIndex = UserDefaults.standard.integer(forKey: "theme")
        segmentedControl.selectedSegmentIndex = themeIndex
    }
    
    @IBAction func changeTheme(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "theme")
        loadTheme()
    }
}
