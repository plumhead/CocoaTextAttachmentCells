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
        let mathStyle = VisualStyle(fontSize: 64, drawFrame: false, inline: false)
    
        let mn1 = MathExpr.Text(text: "x")
        let mn2 = MathExpr.Text(text: "y")
        let n1 = MathExpr.Integer(int: 2)
        let op1 = MathExpr.Operator(lexpr: mn1, op: "+", rexpr: mn2)
        let op2 = MathExpr.Operator(lexpr: mn2, op: "-", rexpr: mn1)
        let bin1 = MathExpr.Binomial(n: mn1, k: op1)
        let brk = MathExpr.Bracketed(left: .LParen, expr: bin1, right: .RParen)

        let seq1 = MathExpr.Sequence(exprs: [op1,brk,op2])
        let fr1 = MathExpr.Fraction(numerator: op1, denominator: seq1)
        let root1 = MathExpr.Root(order: op1, expr: fr1)
        
        let subsup1 = MathExpr.Node(expr: mn1, sub: .None, sup: n1)
        let subsup2 = MathExpr.Node(expr: mn2, sub: .None, sup: subsup1)
        let seq2 = MathExpr.Sequence(exprs: [root1,subsup2])
        
        let sum = MathExpr.Node(expr: MathExpr.Symbol(sym: .Sum), sub: mn1, sup: mn2)
        let seq3 = MathExpr.Sequence(exprs: [sum,seq2])
        
        let expr = seq3.build(withStyle: mathStyle.inlined(false))
        
        
        // Render in the attributed string
        let inline = TextDisplayCell(item: expr, style: mathStyle, usingRenderer: GraphicalImageRender())
        let cell = NSTextAttachment()
        cell.attachmentCell = inline
        let cellstr = NSAttributedString(attachment: cell)
        attr.insertAttributedString(cellstr, atIndex: 3)
        
        editor.textStorage?.replaceCharactersInRange(NSRange(location: 0, length: 0), withAttributedString: attr)
    }

   
}

