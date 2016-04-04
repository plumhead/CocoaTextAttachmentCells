//
//  ViewController.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 04/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var editor: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let inline = TextDisplayCell(withSize: NSSize(width: 100, height: 34))
        let cell = NSTextAttachment()
        cell.attachmentCell = inline
        let cellstr = NSAttributedString(attachment: cell)
        
        editor.textStorage?.replaceCharactersInRange(NSRange(location: 3, length: 0), withAttributedString: cellstr)
    }

}

