//
//  Rendering.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 13/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa


protocol VisualElementRenderer {
    associatedtype RenderType
    func render(item i: VisualPart, withStyle style: VisualStyle) -> (RenderType,ElementSize)
    
    func text(text: String, atPoint p: NSPoint, withStyle style: VisualStyle)
    func box(origin: NSPoint, size: NSSize, withStyle style: VisualStyle)
    func shape(type: ShapeType, frame: NSRect, withStyle style: VisualStyle)
}


protocol VisualElementLayoutHandler {
    func layout(part: VisualPart, x: CGFloat, y: CGFloat, containerSize cs: ElementSize, withStyle style: VisualStyle)
}


extension VisualElementLayoutHandler where Self : VisualElementRenderer {
    func layout(part: VisualPart, x: CGFloat, y: CGFloat, containerSize cs: ElementSize, withStyle style: VisualStyle) {
        if style.drawFrame {
            let frame = part.frame
            box(NSPoint(x: x, y: y), size: NSSize(width: frame.width, height: frame.height), withStyle: style)
        }
        
        switch part {
        case .Spacer(_) : () // Spacer has no layout

        case let .Text(t,_,style) :
            text(t, atPoint: NSPoint(x: x, y: y), withStyle: style)
            
        case let .Sequence(items,frame,style):
            let sb = frame.baseline
            
            var xpos = x
            for i in items {
                let pf = i.frame
                let b = pf.baseline
                let ypos = y + (sb - b)
                layout(i, x: xpos, y: ypos,containerSize: frame, withStyle: style)
                xpos += pf.width
            }
            
        case let .Padded(item,left,_,_,bottom,_,pstyle) :
            layout(item, x: x + left, y: y + bottom, containerSize: part.frame, withStyle: pstyle)

        case let .Pair(item,position,base,frame,style) :
            switch position {
            case .Over:
                layout(base, x: x, y: y, containerSize: frame, withStyle: style)
                layout(item, x: x, y: y + base.frame.height, containerSize: frame, withStyle: style)
            case .Under:
                let of = item.frame
                layout(base, x: x, y: y + of.height, containerSize: frame, withStyle: style)
                layout(item, x: x, y: y, containerSize: frame, withStyle: style)
              
            }
            
        case let .Stack(items,frame,style) :
            // items top to bottom
            var ypos = y
            for i in items.reverse() {
                layout(i, x: x, y: ypos, containerSize: frame, withStyle: style)
                ypos += i.frame.height
            }
            
        case let .Shape(type,frame,style) :
            let b = NSRect(x: x, y: y, width: frame.width, height: frame.height)
            shape(type, frame: b, withStyle: style)
        }
    }
}








