//
//  ViewController.swift
//  iTypist
//
//  Created by Steven Diviney on 06/09/2020.
//  Copyright © 2020 Steven Diviney. All rights reserved.
//
//TODO: Rewrite this thing to use some sort of modern framework, get rid of all this shit state code.

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    // TODO: iPhone layout
    @IBOutlet weak var input: UITextView!
    @IBOutlet weak var displayView: UITextView!
    @IBOutlet weak var accuracy_display: UITextView!
    @IBOutlet weak var info_view: UITextView!
    
    var tf : TextFactory!

    let cr = "⏎"
    let cr_font_size : CGFloat = 32
    
    var lessonString: String = ""
    
    var cursor = 0;
    var current_line = 0;
    var info_line_no = 0;
    
    var succ_count = 0;
    var error_count = 0;
    
    var current_lesson = 1; // This should be passed in from list
    var lesson_finished = false
    
    var timer : CFAbsoluteTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLessonFile(no: current_lesson)
        setTheme()
    }
    
    func setTheme() {
        tf = TextFactory(theme: global_theme)
        global_theme.setTheme(view: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input?.becomeFirstResponder()
        setupLesson()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if cursor == 0 {
            startTimer()
        }

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
        
        if current_line >= lines.count {  //-1 to account for \n at EOF
            print("Done")
            info_view.attributedText = tf.buildString(text: "Advance to next lesson?") // TODO: Handle last lesson finish
            displayView.attributedText = tf.buildString(text: cr)
            lesson_finished = true
            return
        }
        
        var lessonLine = ""
        while true {
            var line = lines[current_line]
            let cmd = line.prefix(2)

            // This is a little hairy now, but I don't want to spend the time making a slick list comprhension
            if cmd == "D:" || cmd == "S:" {
                //Read until the next newline
                // Read the line, then add the next line if it's not empty
                while line != "" {
                    if !lessonLine.isEmpty {
                        lessonLine += "\n"
                    }
                    
                    lessonLine += String(line.suffix(from: line.index(line.startIndex, offsetBy: 2)))
                    current_line += 1
                    line = lines[current_line]
                }
                break
            } else if cmd == "I:" {
                // TODO: I need to clear this if a D: hasen't been found
                let info_line = line.components(separatedBy: cmd).last!
                info_line_no = current_line
                info_view.attributedText = tf.buildString(text: info_line)
            }
            current_line += 1
        }
        
        //TODO: All of this is a mess. All this setter stuff should be done with named methods
        displayView.attributedText = tf.buildString(text: lessonLine)
        setCursor(error: false)
    }
    
    func loadLessonFile(no: Int) {
        let lesson = String(format: "lesson_%d", no)
        let path = Bundle.main.path(forResource: lesson, ofType: "txt") // file path for file "data.txt"
        lessonString = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
    }
    
    func setCursor(error: Bool) {
        let displayText = NSMutableAttributedString(attributedString: displayView.attributedText)
        clearAccuracyDisplay()
        
        // Clear previous
        if cursor > 0 {
            displayText.removeAttribute(.backgroundColor, range: NSRange(location: cursor - 1, length: 1))
            displayText.addAttributes([.foregroundColor: global_theme.textColor], range: NSRange(location: cursor - 1, length: 1))
            displayView.attributedText = displayText
        }
        
        // Special case to show new line
        if cursor == displayText.length {
            displayText.append(NSAttributedString(string: cr, attributes: [.font: UIFont.systemFont(ofSize: cr_font_size)]))
            showAccuracy()
        }
        
        // Set current
        let attributes: [NSAttributedString.Key: Any] = error ?  [.backgroundColor: global_theme.errorColor, .foregroundColor: global_theme.backgroundColor] : [.backgroundColor: global_theme.textColor, .foregroundColor: global_theme.backgroundColor]
        displayText.addAttributes(attributes, range: NSRange(location: cursor, length: 1))
        displayView.attributedText = displayText
    }
    
    //TODO: Make text smaller
    func showAccuracy() {
        let succ_rate : Float = (Float(succ_count) / Float(succ_count + error_count)) * 100
        var accuracy_text = String(format: "Accuracy %.2f%%", succ_rate)
        if succ_rate < 97.0 {
            accuracy_text.append(contentsOf: "\nNeed at least 97%")
            current_line = info_line_no //This will probably break
        }
        
        let wpm = calcWPM()
        if wpm > 0 { //Special case for first lesson having only 4 chars
            accuracy_text.append(contentsOf: String(format: "\nWPM: %0.2f", wpm))
        }
        accuracy_display.attributedText = tf.buildString(text: String(accuracy_text))
        succ_count = 0
        error_count = 0
        resetTimer()
    }
    
    func clearAccuracyDisplay() {
        accuracy_display.attributedText = tf.buildString(text: "")
    }
    
    func calcWPM() -> Double {
        let elapsedTime = CFAbsoluteTimeGetCurrent() - timer
        let line_length = self.displayView.attributedText.string.count
        return Double(line_length / 5 ) / (elapsedTime / 60)
    }
    
    func startTimer() {
        timer = CFAbsoluteTimeGetCurrent()
    }
    
    func resetTimer() {
        timer = 0
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
