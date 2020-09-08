//
//  ViewController.swift
//  iTypist
//
//  Created by Steven Diviney on 06/09/2020.
//  Copyright © 2020 Steven Diviney. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    // TODO: iPhone layout
    @IBOutlet weak var input: UITextView!
    @IBOutlet weak var displayView: UITextView!
    @IBOutlet weak var accuracy_display: UITextView!
    @IBOutlet weak var info_view: UITextView!
    
    let theme = solarized
    let cr = "⏎"
    let font_size : CGFloat = 32
    let cr_font_size : CGFloat = 32
    
    var lessonString: String = ""
    
    var cursor = 0;
    var current_line = 0;
    
    var succ_count = 0;
    var error_count = 0;
    
    var current_lesson = 1; // This should be passed in from list
    var lesson_finished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLessonFile(no: current_lesson)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input?.becomeFirstResponder()
        setupLesson()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let input_c = textView.text.popLast()
        let current_c = displayView.text[cursor]
        
        if input_c == "\n" && current_c == Character(cr) {
            // If last line advance the lesson or just advance the line
            if lesson_finished {
                current_lesson += 1
                loadLessonFile(no: current_lesson)
                lesson_finished = false
                current_line = 0
            } else {
                current_line += 1
            }
            
            cursor = 0
            setupLesson()
            return
        }
        
        if input_c == current_c {
            cursor += 1
            succ_count += 1
            setCursor(error: false)
        } else {
            error_count += 1
            setCursor(error: true)
        }
    }
    
    private

    func setupLesson() {

        // Read in the file, filling in the information and data buffer
        let lines = lessonString.components(separatedBy: "\n")
        
        if current_line == (lines.count - 1) {  //-1 to account for \n at EOF
            print("Done")
            setText(text: "Advance to next lesson?", view: info_view) // TODO: Handle last lesson
            setText(text: cr, view: displayView)
            lesson_finished = true
            return
        }
        
        var lessonLine = ""
        while true {
            let line = lines[current_line]
            let cmd = line.prefix(2)

            // TODO: Add support for S: (this means a sentance I presume? Does it have different rules?)
            // TODO: Add support for multiline statements. Need to read until empty line. How to render? Hopefully just stick it in the buffer
            if cmd == "D:" {
                lessonLine = line.components(separatedBy: cmd).last!
                break
            } else if cmd == "I:" {
                // TODO: I need to clear this if a D: hasen't been found
                let info_line = line.components(separatedBy: cmd).last!
                setText(text: info_line, view: info_view)
            }
            current_line += 1
        }
        
        setText(text: lessonLine, view: displayView)
        setCursor(error: false)
    }
    
    func loadLessonFile(no: Int) {
        let lesson = String(format: "lesson_%d", no)
        let path = Bundle.main.path(forResource: lesson, ofType: "txt") // file path for file "data.txt"
        lessonString = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
    }
    
    func setText(text: String, view: UITextView) {
        let font = UIFont.systemFont(ofSize: font_size)
        let attributes:  [NSAttributedString.Key: Any] =  [NSAttributedString.Key.font: font, NSAttributedString.Key.kern: 5, NSAttributedString.Key.foregroundColor: theme.textColor]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        view.attributedText = attributedString
    }
    
    func setCursor(error: Bool) {
        let displayText = NSMutableAttributedString(attributedString: displayView.attributedText)
        clearAccuracy()
        
        // Clear previous
        if cursor > 0 {
            displayText.removeAttribute(.backgroundColor, range: NSRange(location: cursor - 1, length: 1))
            displayText.addAttributes([.foregroundColor: theme.textColor], range: NSRange(location: cursor - 1, length: 1))
            displayView.attributedText = displayText
        }
        
        // Special case to show new line
        if cursor == displayText.length {
            displayText.append(NSAttributedString(string: cr, attributes: [.font: UIFont.systemFont(ofSize: cr_font_size)]))
            showAccuracy()
        }
        
        // Set current
        let attributes: [NSAttributedString.Key: Any] = error ?  [.backgroundColor: theme.errorColor, .foregroundColor: theme.backgroundColor] : [.backgroundColor: theme.textColor, .foregroundColor: theme.backgroundColor]
        displayText.addAttributes(attributes, range: NSRange(location: cursor, length: 1))
        displayView.attributedText = displayText
    }
    
    //TODO: Make text smaller
    func showAccuracy() {
        let succ_rate : Float = (Float(succ_count) / Float(succ_count + error_count)) * 100
        var accuracy_text = String(format: "Accuracy %.2f%%", succ_rate)
        if succ_rate < 97.0 {
            accuracy_text.append(contentsOf: "\nNeed at least 97%")
            current_line -= 1 //This will probably break
        }
        setText(text: String(accuracy_text), view: accuracy_display)
        succ_count = 0
        error_count = 0
    }
    
    func clearAccuracy() {
        setText(text: "", view: accuracy_display)
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}
