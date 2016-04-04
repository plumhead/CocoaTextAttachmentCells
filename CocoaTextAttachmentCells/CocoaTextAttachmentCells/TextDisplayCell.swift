//
//  TextDisplayCell.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 04/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa


class TextDisplayCell : NSTextAttachmentCell {
    var size : NSSize
    
    init(withSize s: NSSize) {
        self.size = s
        
        let img = NSImage(size: s, flipped: false) { (r) -> Bool in
            let p = NSBezierPath(rect: r)
            NSColor.greenColor().setFill()
            p.fill()
            return true
        }
        
        super.init(imageCell: img)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func cellSize() -> NSSize {
        return size
    }
    
}