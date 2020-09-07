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
    
    var cursor = 0;
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input?.becomeFirstResponder()
        setupLesson()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let input_c = textView.text.popLast()
        let current_c = displayView.text[cursor]
        
        if input_c == current_c {
            cursor += 1
            setCursor()
        } else {
            print("no")
        }
        
    }
    
    private
    
    func setupLesson() {
        let lessonString = """
        fff jjj fff jjj fff jjj fff jjj
        fgf jhj fgf jhj fgf jhj fgf jhj
        """
        setText(text: lessonString)
        setCursor()
    }
    
    func setText(text: String) {
        let font = UIFont.systemFont(ofSize: 32)
        let attributes:  [NSAttributedString.Key: Any] =  [NSAttributedString.Key.font: font, NSAttributedString.Key.kern: 5]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        displayView.attributedText = attributedString
    }
    
    func setCursor() {
        let displayText = NSMutableAttributedString(attributedString: displayView.attributedText)

        
        if cursor > 0 {
            displayText.removeAttribute(.backgroundColor, range: NSRange(location: cursor - 1, length: 1))
            displayView.attributedText = displayText
        }
        
        let attributes: [NSAttributedString.Key: Any] = [.backgroundColor: UIColor.green]
        displayText.addAttributes(attributes, range: NSRange(location: cursor, length: 1))
        displayView.attributedText = displayText
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

