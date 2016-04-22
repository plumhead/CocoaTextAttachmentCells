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
        
        let text = "AScx"
        let font = NSFont.systemFontOfSize(64)
        let attr = NSMutableAttributedString(string: text, attributes: [NSForegroundColorAttributeName:NSColor.blackColor(), NSFontAttributeName:font])

        // Build the display element part
        let initialStyle = VisualStyle(fontSize: 64, drawFrame: false)
        
        let w1 = "A".build(withStyle: initialStyle.bigger)
        let w2 = "BC".build(withStyle: initialStyle.smaller.smaller)
        let w2p = VisualPart.padded(w2, left: 50.0, right: 10, top: 0, bottom: 30, style: initialStyle)
        let w3 = VisualPart.over(w1, base: w2p, withStyle: initialStyle.framed)
        let w4 = VisualPart.over(w2p, base: w1, withStyle: initialStyle.framed)
        let w5 = VisualPart.over(w1, base: w2p, withStyle: initialStyle)
        let w6 = VisualPart.under(w1, base: w1, withStyle: initialStyle)
        
        let st1 = VisualPart.stack([w1,w2,w4], withStyle: initialStyle)
        let st1f = st1.frame
        let cf = ElementSize(width: 30, height: st1f.height, realWidth: 30, baseline: st1f.baseline, xHeight: st1f.xHeight)
        let lc = leftCurve(cf)
        let leftcurve = VisualPart.Shape(type: lc, frame: cf, style: initialStyle)
        let rc = rightCurve(cf)
        let rightcurve = VisualPart.Shape(type: rc, frame: cf, style: initialStyle)
        let stseq = VisualPart.sequence([leftcurve,st1,rightcurve], withStyle: initialStyle)
        
        let w1f = w1.frame
        let of = ElementSize(width: w1f.width, height: w1f.width, realWidth: w1f.width, baseline: w1f.baseline, xHeight: w1f.xHeight)
        let circle = oval(of)
        let circlepart = VisualPart.Shape(type: circle, frame: of, style: initialStyle)
        let circleOverA = VisualPart.over(circlepart, base: w1, withStyle: initialStyle)
        let circleUnderBC = VisualPart.under(circlepart, base: w2, withStyle: initialStyle)
        
        let seq = VisualPart.sequence([w3,w6,w5,circleOverA,circleUnderBC,stseq], withStyle: initialStyle, withSpacing: 10.0)
        
        // Render in the attributed string
        let inline = TextDisplayCell(item: seq, style: initialStyle, usingRenderer: GraphicalImageRender())
        let cell = NSTextAttachment()
        cell.attachmentCell = inline
        let cellstr = NSAttributedString(attachment: cell)
        attr.insertAttributedString(cellstr, atIndex: 3)
        
        editor.textStorage?.replaceCharactersInRange(NSRange(location: 0, length: 0), withAttributedString: attr)
    }

    func leftCurve(f: ElementSize) -> ShapeType {
        let sp = NSPoint(x: f.width, y: 0)
        let cp1 = NSPoint(x: 0, y: f.height * 0.25)
        let cp2 = NSPoint(x: 0, y: f.height * 0.75)
        let ep = NSPoint(x: f.width, y: f.height)
        return ShapeType.Curve(from: sp, cp1: cp1, cp2: cp2, to: ep)
    }
    
    func rightCurve(f: ElementSize) -> ShapeType {
        let sp = NSPoint(x: 0, y: 0)
        let cp1 = NSPoint(x: f.width, y: f.height * 0.25)
        let cp2 = NSPoint(x: f.width, y: f.height * 0.75)
        let ep = NSPoint(x: 0, y: f.height)
        return ShapeType.Curve(from: sp, cp1: cp1, cp2: cp2, to: ep)
    }
    
    func oval(f: ElementSize) -> ShapeType {
        return ShapeType.ComplexPath(f: { (r, s) -> NSBezierPath in
            let p = NSBezierPath(ovalInRect: r)
            NSColor.greenColor().setStroke()
            p.lineWidth = 2
            return p
        })
    }
}

