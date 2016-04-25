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
        
        let font = NSFont.systemFontOfSize(18)
        let attr = NSMutableAttributedString(string: "", attributes: [NSForegroundColorAttributeName:NSColor.blackColor(), NSFontAttributeName:font])

        // Build the display element part
        let mathStyle = VisualStyle(fontSize: 18, drawFrame: false, inline: false, italic: false, bold: false)
    
        let py = MathEquations.pythagorasTheorum()
        let logs = MathEquations.logarithms()
        let calc = MathEquations.calculus()
        let log = MathEquations.lawOfGravity()
        let sqmone = MathEquations.rootMinusOne()
        let poly = MathEquations.polyhedra()
        let nd = MathEquations.normalDistribution()
        let we = MathEquations.waveEquation()
        let ns = MathEquations.navierStokes()
        let therm = MathEquations.thermo()
        let rel = MathEquations.relativity()
        let sch = MathEquations.schrodinger()
        let inf = MathEquations.infoTheory()
        let chaos = MathEquations.chaos()
        let bs = MathEquations.blackScholes()
        let four = MathEquations.fourierTransform()
        
        for (pre,ex,post) in [py,logs,calc,log, sqmone, poly, nd, we, four, ns, therm, rel, sch, inf, chaos, bs] {
            let expr = ex.build(withStyle: mathStyle)
            let inline = TextDisplayCell(item: expr, style: mathStyle, usingRenderer: GraphicalImageRender())
            let cell = NSTextAttachment()
            cell.attachmentCell = inline
            let cellstr = NSAttributedString(attachment: cell)
            
            attr.appendAttributedString(pre)
            attr.appendAttributedString(cellstr)
            attr.appendAttributedString(post)
        }
        
        editor.textStorage?.replaceCharactersInRange(NSRange(location: 0, length: 0), withAttributedString: attr)
    }

   
}

