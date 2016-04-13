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
        
        let text = "AScxtyz"
        let font = NSFont.systemFontOfSize(64)
        let attr = NSMutableAttributedString(string: text, attributes: [NSForegroundColorAttributeName:NSColor.blackColor(), NSFontAttributeName:font])

        let content = "cyQWTPHSApjx"
        let cellSize = content.size(withAttributes: [NSFontAttributeName:font], constrainedTo: NSSize(width: 5000, height: 5000))
        let h = max(cellSize.height, font.ascender + fabs(font.descender))

        let inline = TextDisplayCell(item: content, style: VisualStyle(fontSize: 64), usingRenderer: GraphicalImageRender())
        let cell = NSTextAttachment()
        cell.attachmentCell = inline
        let cellstr = NSAttributedString(attachment: cell)
        attr.insertAttributedString(cellstr, atIndex: 3)
        
        editor.textStorage?.replaceCharactersInRange(NSRange(location: 0, length: 0), withAttributedString: attr)
    }

}

