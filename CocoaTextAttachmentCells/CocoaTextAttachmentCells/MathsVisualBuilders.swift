//
//  MathsVisualBuilders.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 24/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa



extension MathExpr : VisualPartConvertible {
    func shouldInline(inline : Bool) -> Bool  {
        switch self {
        case .Symbol(.Sum) : return inline
        case _ : return true
        }
    }
    
    func build(withStyle style: VisualStyle) -> VisualPart {
        switch self {
        case let .Text(t) :
            return t.build(withStyle: style)
            
        case let .Integer(n) :
            return "\(n)".build(withStyle: style)
            
        case let .Number(n) :
            return "\(n)".build(withStyle: style)
            
        case let .Operator(le,op,re) :
            let lev = le.build(withStyle: style)
            let opv = op.build(withStyle: style)
            let rev = re.build(withStyle: style)
            return VisualPart.sequence([lev,opv,rev], withStyle: style, withSpacing: 10.0)
            
        case let .Unary(op,ex) :
            let opv = op.build(withStyle: style)
            let exv = ex.build(withStyle: style)
            return VisualPart.sequence([opv,exv], withStyle: style)
            
        case let .Fraction(num,den) :
            var numv = num.build(withStyle: style)
            var denv = den.build(withStyle: style)
            let nf = numv.frame
            let df = denv.frame
            let w = max(nf.width, df.width)
            
            let sp = NSPoint(x: 0, y: 0)
            let ep = NSPoint(x: w, y: 0)
            let lns = ShapeType.Path(points: [sp,ep])
            let font = NSFont.systemFontOfSize(style.fontSize)
            let lnf = ElementSize(width: w, height: 2, realWidth: w, baseline: -(font.xHeight/2), xHeight: 1)
            let ln = VisualPart.Shape(type: lns, frame: lnf, style: style)
            
            let pad1 = w - nf.width
            if pad1 > 0 {
                numv = VisualPart.padded(numv, left: pad1/2, right: pad1/2, top: 0, bottom: 0, style: style)
            }
            
            let pad2 = w - df.width
            if pad2 > 0 {
                denv = VisualPart.padded(denv, left: pad2/2, right: pad2/2, top: 0, bottom: 0, style: style)
            }
            
            return VisualPart.stack([numv,ln,denv], withStyle: style)
            
        case let .Sequence(exprs) :
            let ve = exprs.map {$0.build(withStyle: style)}
            return VisualPart.sequence(ve, withStyle: style)
            
        case let .Binomial(ne,ke) :
            let n1 = ne.build(withStyle: style)
            let n2 = ke.build(withStyle: style)
            return VisualPart.stack([n1,n2], withStyle: style)
            
        case let .Root(oe,ex) :
            let degree = oe.flatMap{$0.build(withStyle: style.smaller.smaller)}
            let root = ex.build(withStyle: style)
            let rf = root.frame
            
            let ln1p = VisualPart.line(NSPoint(x: 0, y: 0), ep: NSPoint(x: rf.width, y: 0), fr: ElementSize(width: rf.width, height: 1, realWidth: rf.width, baseline: 0, xHeight: 0), withStyle: style)
            let s1 = VisualPart.over(ln1p, base: root, withStyle: style)
            
            let f2 = s1.frame
            let ln2p = VisualPart.line( NSPoint(x: 0, y: 0), ep: NSPoint(x: 10, y: rf.height), fr: ElementSize(width: 10, height: f2.height , realWidth: 10, baseline: f2.baseline , xHeight: f2.xHeight), withStyle: style)
            
            if let d = degree {
                let sp = NSPoint(x: d.frame.width, y: 0)
                let mp = NSPoint(x: d.frame.width - 10, y: rf.height * 0.3)
                let ep = NSPoint(x: d.frame.width - 13, y: (rf.height * 0.3) - 4)
                let lf = ElementSize(width: 10, height: rf.height * 0.3 , realWidth: 10, baseline: f2.baseline , xHeight: 0)
                let sh = ShapeType.Path(points: [sp,mp,ep])
                let ln3p = VisualPart.Shape(type: sh, frame: lf, style: style)
                let s2 = VisualPart.over(d, base: ln3p, withStyle: style)
                return VisualPart.sequence([s2,ln2p,s1], withStyle: style)
            }
            else {
                let ln3p = VisualPart.line(NSPoint(x: 10, y: 0), ep: NSPoint(x: 0, y: rf.height * 0.3), fr: ElementSize(width: 10, height: f2.height , realWidth: 10, baseline: f2.baseline , xHeight: f2.xHeight), withStyle: style)
                return VisualPart.sequence([ln3p,ln2p,s1], withStyle: style)
            }
            
        case let .Bracketed(lsym,expr,rsym) :
            let exv = expr.build(withStyle: style)
            let exvf = exv.frame
            let bf = ElementSize(width: 10, height: exvf.height, realWidth: 10, baseline: exvf.baseline, xHeight: exvf.xHeight)
            let lb = MathExpr.leftParen(bf)
            let rb = MathExpr.rightParen(bf)
            let lbv = VisualPart.Shape(type: lb, frame: bf, style: style)
            let rbv = VisualPart.Shape(type: rb, frame: bf, style: style)
            return VisualPart.sequence([lbv,exv,rbv], withStyle: style)
            
        case let .Node(expr,sub,sup) :
            let node = expr.build(withStyle: style)
            let sopt = style.smaller.smaller
            let subpart = sub?.build(withStyle: sopt)
            let suppart = sup?.build(withStyle: sopt)
            
            if expr.shouldInline(style.inline) {
                let font = NSFont.systemFontOfSize(style.fontSize)
                switch (subpart,suppart) {
                case (.None,.None) : return node
                case let (s?,.None) :
                    let f = node.frame
                    let spch = f.height - f.baseline - font.xHeight / 2
                    let spc = VisualPart.spacer(1, height: spch)
                    let st = VisualPart.stack([spc,s], withStyle: style)
                    return VisualPart.sequence([node,st], withStyle: style)
                case let (.None,s?) :
                    let f = node.frame
                    let spch = f.baseline + font.xHeight / 2
                    let spc = VisualPart.spacer(1, height: spch)
                    let st = VisualPart.stack([s,spc], withStyle: style)
                    return VisualPart.sequence([node,st], withStyle: style)
                case let (subn?,supn?) :
                    let st = VisualPart.stack([supn,subn], withStyle: style)
                    return VisualPart.sequence([node,st], withStyle: style)
                }
            }
            else {
                switch (subpart,suppart) {
                case (.None,.None) : return node
                case let (s?,.None) : return VisualPart.under(s, base: node, withStyle: style)
                case let (.None,s?) : return VisualPart.over(s, base: node, withStyle: style)
                case let (subn?,supn?) : return VisualPart.stack([supn,node,subn], withStyle: style)
                }
            }
            
        case let .Symbol(sym) :
            return MathExpr.symbolPart(sym, withStyle: style)
            
        }
    }
    
    static func symbolPart(type: MathSymbol, withStyle style: VisualStyle) -> VisualPart {
        switch type {
        case .Sum:
            let font = NSFont.systemFontOfSize(style.fontSize)
            let f = VisualPart.textSize(forText: "W", withFont: font)
            let fs = ElementSize(width: f.width, height: f.height , realWidth: f.realWidth, baseline: f.baseline, xHeight: f.xHeight)
            
            let path = [
                NSPoint(x: fs.width, y: 5),
                NSPoint(x: fs.width * 0.9, y: 1),
                NSPoint(x: 0, y: 1),
                NSPoint(x: fs.width * 0.2, y: fs.height / 2),
                NSPoint(x: 0, y: fs.height - 2),
                NSPoint(x: fs.width * 0.9, y: fs.height - 2),
                NSPoint(x: fs.width, y: fs.height - 5)
            ]
            
            let space = VisualPart.Spacer(frame: ElementSize(width: 2, height: 2, realWidth: 2, baseline: 1, xHeight: 1))
            let symbol = VisualPart.Shape(type: ShapeType.Path(points: path), frame: fs, style: style)
            return VisualPart.sequence([symbol,space], withStyle: style)
        }
    }
    
    static func leftParen(f: ElementSize) -> ShapeType {
        let sp = NSPoint(x: f.width, y: 0)
        let cp1 = NSPoint(x: 0, y: f.height * 0.25)
        let cp2 = NSPoint(x: 0, y: f.height * 0.75)
        let ep = NSPoint(x: f.width, y: f.height)
        return ShapeType.Curve(from: sp, cp1: cp1, cp2: cp2, to: ep)
    }
    
    static func rightParen(f: ElementSize) -> ShapeType {
        let sp = NSPoint(x: 0, y: 0)
        let cp1 = NSPoint(x: f.width, y: f.height * 0.25)
        let cp2 = NSPoint(x: f.width, y: f.height * 0.75)
        let ep = NSPoint(x: 0, y: f.height)
        return ShapeType.Curve(from: sp, cp1: cp1, cp2: cp2, to: ep)
    }
}



