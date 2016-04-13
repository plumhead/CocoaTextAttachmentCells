//
//  ImageRenderer.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 13/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa



class GraphicalImageRender : VisualElementRenderer, VisualElementLayoutHandler {
    typealias RenderType = NSImage
    
    func text(text: String, atPoint p: NSPoint, withStyle style: VisualStyle) {
        let ns = text as NSString
        let font = NSFont.systemFontOfSize(style.fontSize)
        ns.drawAtPoint(p, withAttributes: [NSFontAttributeName:font,NSForegroundColorAttributeName:NSColor.blackColor()])
    }
    
    func render(item i: VisualPartCreator, withStyle style: VisualStyle) -> (RenderType,ElementSize) {
        let part = i.build(withStyle: style)
        let s = part.frame
        
        let inlineImg = NSImage(size: NSSize(width: s.width, height: s.height), flipped: false) {(r) -> Bool in
            self.layout(part, x: 0, y:0, containerSize: part.frame, withStyle: style)
            return true
        }
        return (inlineImg,s)
    }
}
