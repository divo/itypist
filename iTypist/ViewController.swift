//
//  ViewController.swift
//  iTypist
//
//  Created by Steven Diviney on 06/09/2020.
//  Copyright © 2020 Steven Diviney. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var input: UITextView!
    @IBOutlet weak var displayView: UITextView!
    @IBOutlet weak var accuracy_label: UILabel!
    
    let textColor = UIColor(red: 0.67, green: 0.80, blue: 0.81, alpha: 1.00)
    let backgroundColor = UIColor(red: 0.00, green: 0.16, blue: 0.20, alpha: 1.00)
    let errorColor = UIColor(red: 0.83, green: 0.33, blue: 0.04, alpha: 1.00)
    let cr = "⏎"
    let font_size : CGFloat = 32
    let cr_font_size : CGFloat = 32
    
    var lessonString: String = ""
    
    var cursor = 0;
    var current_line = 0;
    
    var succ_count = 0;
    var error_count = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lessonString = loadLessonFile()!
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
            current_line += 1
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
        var lessonLine = ""
        while true {
            let line = lines[current_line]
            let cmd = line.prefix(2)
            if cmd == "D:" {
                current_line += 1
                lessonLine = line.components(separatedBy: cmd).last!
                break
            } else {
                current_line += 1
            }
        }
        
        setText(text: lessonLine)
        
        if current_line == lines.count {
            print("Done")
            return
        }
        
        setCursor(error: false)
    }
    
    func loadLessonFile() -> String? {
        let path = Bundle.main.path(forResource: "lesson_data", ofType: "txt") // file path for file "data.txt"
        return try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
    }
    
    func setText(text: String) {
        let font = UIFont.systemFont(ofSize: font_size)
        let attributes:  [NSAttributedString.Key: Any] =  [NSAttributedString.Key.font: font, NSAttributedString.Key.kern: 5, NSAttributedString.Key.foregroundColor: textColor]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        displayView.attributedText = attributedString
    }
    
    func setCursor(error: Bool) {
        let displayText = NSMutableAttributedString(attributedString: displayView.attributedText)

        // Clear previous
        if cursor > 0 {
            displayText.removeAttribute(.backgroundColor, range: NSRange(location: cursor - 1, length: 1))
            displayText.addAttributes([.foregroundColor: textColor], range: NSRange(location: cursor - 1, length: 1))
            displayView.attributedText = displayText
        }
        
        // Special case to show new line
        if cursor == displayText.length {
            displayText.append(NSAttributedString(string: cr, attributes: [.font: UIFont.systemFont(ofSize: cr_font_size)]))
        }
        
        // Set current
        let attributes: [NSAttributedString.Key: Any] = error ?  [.backgroundColor: errorColor, .foregroundColor: backgroundColor] : [.backgroundColor: textColor, .foregroundColor: backgroundColor]
        displayText.addAttributes(attributes, range: NSRange(location: cursor, length: 1))
        displayView.attributedText = displayText
        
        updateAccuracy()
    }
    
    //TODO: Style this and move else where
    func updateAccuracy() {
        if succ_count == 0 { return }
        let rate : Float = (Float(succ_count) / Float(succ_count + error_count)) * 100
        accuracy_label.text = String(rate)
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
