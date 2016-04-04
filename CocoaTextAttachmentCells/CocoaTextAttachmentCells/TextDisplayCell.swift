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
    var displayFont : NSFont
    
    init(withSize s: NSSize, forContent c: String, withFont font: NSFont) {
        self.size = s
        self.displayFont = font
        
        let img = NSImage(size: s, flipped: false) { (r) -> Bool in
            (c as NSString).drawInRect(r, withAttributes: [NSFontAttributeName:font])
            
            NSColor.blueColor().setStroke()
            let blp = NSBezierPath()
            blp.moveToPoint(NSPoint(x: 0, y: 0))
            blp.lineToPoint(NSPoint(x: s.width, y: 0))
            blp.stroke()
            NSColor.redColor().setStroke()
            let lp = NSBezierPath()
            lp.moveToPoint(NSPoint(x: 0, y: fabs(font.descender)))
            lp.lineToPoint(NSPoint(x: s.width, y: fabs(font.descender)))
            lp.stroke()
            let lp2 = NSBezierPath()
            NSColor.cyanColor().setStroke()
            lp2.moveToPoint(NSPoint(x: 0, y: fabs(font.xHeight)))
            lp2.lineToPoint(NSPoint(x: s.width, y: fabs(font.xHeight)))
            lp2.stroke()
            let lp3 = NSBezierPath()
            NSColor.greenColor().setStroke()
            lp3.moveToPoint(NSPoint(x: 0, y: fabs(font.ascender)))
            lp3.lineToPoint(NSPoint(x: s.width, y: fabs(font.ascender)))
            lp3.stroke()
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
    
    override func cellBaselineOffset() -> NSPoint {
        return NSPoint(x: 0, y: displayFont.descender)
    }
}