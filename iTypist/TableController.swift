//
//  TableController.swift
//  iTypist
//
//  Created by Steven Diviney on 07/09/2020.
//  Copyright © 2020 Steven Diviney. All rights reserved.
//

import UIKit

class TableController: UITableViewController {
    var lessons: [String] = []
    var selected_row = 0
    
    var theme = solarized
    var tf : TextFactory!
    
    override func viewDidLoad() {
        lessons = loadLessonIndex()
        tf = TextFactory(theme: theme)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lesson_cell", for: indexPath)
        cell.textLabel?.attributedText = tf.buildString(text: lessons[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_row = indexPath.row
        self.performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ViewController
        dest.current_lesson = selected_row + 1
    }
    
    private
    
    func loadLessonIndex() -> [String] {
        let path = Bundle.main.path(forResource: "lesson_index", ofType: "txt")
        return try! String(contentsOfFile: path!, encoding: String.Encoding.utf8).components(separatedBy: "\n")
    }
}
