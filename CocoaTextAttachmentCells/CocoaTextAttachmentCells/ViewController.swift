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
        let words = ["Word1","Word2"] as [VisualPartConvertible]
        let (parts,_) = words.reduce(([],initialStyle)) { (a, p) -> ([VisualPart],VisualStyle) in
            return (a.0 + [p.build(withStyle: a.1)], a.1.smaller.smaller)
        }
        
        let (parts2,_) = words.reduce(([],initialStyle)) { (a, p) -> ([VisualPart],VisualStyle) in
            return (a.0 + [p.build(withStyle: a.1)], a.1.bigger.bigger)
        }
        
        let w1 = "A".build(withStyle: initialStyle.bigger)
        let w2 = "BC".build(withStyle: initialStyle.smaller.smaller)
        let w2p = VisualPart.padded(w2, left: 50.0, right: 10, top: 0, bottom: 30, style: initialStyle)
        let w3 = VisualPart.over(w1, base: w2p, withStyle: initialStyle.framed)
        let w4 = VisualPart.over(w2p, base: w1, withStyle: initialStyle.framed)

        let seq = VisualPart.sequence(parts, withStyle: initialStyle, withSpacing: 50.0)
        let seq2 = VisualPart.sequence(parts2, withStyle: initialStyle, withSpacing: 5.0)
        let vp = VisualPart.under(w3, base: seq, withStyle: initialStyle)
        
        let stack = VisualPart.stack([seq,seq2], withStyle: initialStyle)
        let sf = stack.frame
        let sp = NSPoint(x: 10, y: 0)
        let ep = NSPoint(x: 10, y: sf.height)
        let lnf = ElementSize(width: 20, height: sf.height, realWidth: 20, baseline: sf.baseline, xHeight: sf.xHeight)
        let ln = ShapeType.Path(points: [sp,ep])
        let line = VisualPart.Shape(type: ln, frame: lnf, style: initialStyle)
        
        let seq3 = VisualPart.sequence([line,stack,line,vp,seq2], withStyle: initialStyle)
        
        let seq3f = seq3.frame
        let spx = NSPoint(x: 0, y: 0)
        let epx = NSPoint(x: seq3f.width, y: 0)
        let cp1 = NSPoint(x: seq3f.width / 4, y: 30)
        let cp2 = NSPoint(x: seq3f.width * 0.75, y: 30)
        let curve = ShapeType.Curve(from: spx, cp1: cp1, cp2: cp2, to: epx)
        let cf = ElementSize(width: seq3f.width, height: 30, realWidth: seq3f.width, baseline: 0, xHeight: 0)
        let cp = VisualPart.Shape(type: curve, frame: cf, style: initialStyle)
        
        let item = VisualPart.over(cp, base: seq3, withStyle: initialStyle)
        
        let item2 = VisualPart.sequence([w3,w4,item], withStyle: initialStyle)
        // Render in the attributed string
        let inline = TextDisplayCell(item: item2, style: initialStyle, usingRenderer: GraphicalImageRender())
        let cell = NSTextAttachment()
        cell.attachmentCell = inline
        let cellstr = NSAttributedString(attachment: cell)
        attr.insertAttributedString(cellstr, atIndex: 3)
        
        editor.textStorage?.replaceCharactersInRange(NSRange(location: 0, length: 0), withAttributedString: attr)
    }

}

