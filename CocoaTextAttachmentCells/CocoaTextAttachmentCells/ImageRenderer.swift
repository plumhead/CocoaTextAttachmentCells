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
        guard let ctx = NSGraphicsContext.currentContext() else {return}
        CGContextSaveGState(ctx.CGContext)
        defer {CGContextRestoreGState(ctx.CGContext)}

        let ns = text as NSString
        let font = style.displayFont()
        ns.drawAtPoint(p, withAttributes: [NSFontAttributeName:font,NSForegroundColorAttributeName:NSColor.blackColor()])
    }
    
    func box(origin: NSPoint, size: NSSize, withStyle style: VisualStyle) {
        guard let ctx = NSGraphicsContext.currentContext() else {return}
        CGContextSaveGState(ctx.CGContext)
        defer {CGContextRestoreGState(ctx.CGContext)}

        let r = NSRect(origin: origin, size: size)
        let p = NSBezierPath(rect: r)
        NSColor.blackColor().setStroke()
        p.lineWidth = 1
        p.stroke()
    }
        
    func shape(type: ShapeType, frame f: NSRect, withStyle style: VisualStyle) {
        guard let ctx = NSGraphicsContext.currentContext() else {return}
        CGContextSaveGState(ctx.CGContext)
        defer {CGContextRestoreGState(ctx.CGContext)}
        
        switch type {
        case .Empty: ()

        case let .Path(pts) :
            switch pts.count {
            case 0: return  // no path
            case 1 : return // single point
            case let n :
                let p = NSBezierPath()
                p.lineWidth = 1.0
                p.moveToPoint(pts[0] + f.origin)
                for i in 1..<n {
                    p.lineToPoint(pts[i] + f.origin)
                }
                
                p.stroke()
            }
            
        case let .Curve(from,cp1,cp2,to) :
            let p = NSBezierPath()
            p.lineWidth = 1
            p.moveToPoint(from + f.origin)
            p.curveToPoint(to + f.origin, controlPoint1: cp1 + f.origin, controlPoint2: cp2 + f.origin)
            p.stroke()
            
        case let .ComplexPath(path) :
            let p = path(f,style)
            p.stroke()
        }
    }

    
    func render(item i: VisualPart, withStyle style: VisualStyle) -> (RenderType,ElementSize) {
        let f = i.frame
        let inlineImg = NSImage(size: NSSize(width: f.width, height: f.height), flipped: false) {(r) -> Bool in
            self.layout(i, x: 0, y:0, containerSize: f, withStyle: style)
            return true
        }
        return (inlineImg,f)
    }
}
