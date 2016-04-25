//
//  MathsVisualBuilders.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 24/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa


extension MathSymbolContentType : VisualPartConvertible {
    
    static func integralShape(inBounds b: NSRect, style: VisualStyle) -> NSBezierPath {
        let p = NSBezierPath()
        
        let dh = b.height / 10
        let dw = b.width / 8
        p.moveToPoint(NSPoint(x: b.minX, y: b.minY + dh))
        
        let ep = NSPoint(x: b.midX, y: b.minY + dh)
        let cp1 = NSPoint(x: b.minX + dw, y: b.minY)
        let cp2 = NSPoint(x: b.midX - dw, y: b.minY)
        p.curveToPoint(ep, controlPoint1: cp1, controlPoint2: cp2)
        p.lineToPoint(NSPoint(x: b.midX, y: b.maxY - dh))
        
        let ep2 = NSPoint(x: b.maxX, y: b.maxY - dh)
        let cp21 = NSPoint(x: b.midX + dw, y: b.maxY)
        let cp22 = NSPoint(x: b.maxX - dw, y: b.maxY)
        
        p.curveToPoint(ep2, controlPoint1: cp21, controlPoint2: cp22)
        return p
    }
    
    func symbolPart(type: MathSymbolType, withStyle style: VisualStyle) -> VisualPart {
        switch type {
        case .Sum:
            let font = style.displayFont()
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
       
        case .Integral:
            let font = style.displayFont()
            let s = VisualPart.textSize(forText: "W", withFont: font)
            let fs = ElementSize(width: 8, height: s.height, realWidth: 8, baseline: s.baseline, xHeight: s.xHeight)
            return VisualPart.Shape(type: ShapeType.ComplexPath(f: MathSymbolContentType.integralShape), frame: fs, style: style)
          
        }
    }
    
    func build(withStyle style: VisualStyle) -> VisualPart {
        let font = style.displayFont()
        
        switch self {
        case let MathSymbolContentType.Text(text: t) where Double(t) != nil:
            let f = VisualPart.textSize(forText: t, withFont: font)
            return VisualPart.Text(t: t, frame: f, style: style)
            
        case let MathSymbolContentType.Text(text: t) :
            let f = VisualPart.textSize(forText: t, withFont: font)
            return VisualPart.Text(t: t, frame: f, style: style.italisised(true))
            
        case let MathSymbolContentType.Operator(op: op) :
            let f = VisualPart.textSize(forText: op, withFont: font)
            let space = VisualPart.Spacer(frame: ElementSize(width: 3, height: 2, realWidth: 3, baseline: 1, xHeight: 1))
            let part = VisualPart.Text(t: op, frame: f, style: style)
            return VisualPart.sequence([space,part,space], withStyle: style)
            
        case let MathSymbolContentType.Symbol(mt) :
            return symbolPart(mt, withStyle: style)
            
        case let MathSymbolContentType.Function(type: ft) :
            let f = VisualPart.textSize(forText: ft.rawValue, withFont: font)
            let space = VisualPart.Spacer(frame: ElementSize(width: 3, height: f.height, realWidth: 3, baseline: f.baseline, xHeight: f.xHeight))
            let part = VisualPart.Text(t: ft.rawValue, frame: f, style: style)
            return VisualPart.sequence([part,space], withStyle: style)
        }
    }
}

extension MathSymbol : VisualPartConvertible {
    func build(withStyle style: VisualStyle) -> VisualPart {
        let node = symbol.build(withStyle: style)
        let sopt = style.smaller.smaller
        let subpart = symSubscript?.build(withStyle: sopt)
        let suppart = symSuperscript?.build(withStyle: sopt)
        
        if shouldInline(style.inline) {
            let font = style.displayFont()
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
    }
}


extension MathExpr : VisualPartConvertible {
    
    func build(withStyle style: VisualStyle) -> VisualPart {
        switch self {
        case let .Symbol(s) : return s.build(withStyle: style)
        case let .Unary(op,ex) : return MathExpr.unary(op, ex: ex, withStyle: style)
        case let .Fraction(num,den) : return MathExpr.fraction(num, den: den, withStyle: style)
        case let .Sequence(exprs) : return MathExpr.mathSequence(exprs, withStyle: style)
        case let .Binomial(ne,ke) : return MathExpr.binomial(ne, ke: ke, withStyle: style)
        case let .Root(oe,ex) : return MathExpr.root(oe, ex: ex, withStyle: style)
        case let .Bracketed(lsym,expr,rsym) : return MathExpr.bracketed(lsym, expr: expr, rsym: rsym, withStyle: style)
        }
    }
    
    static func fraction(num: MathExpr, den: MathExpr, withStyle style: VisualStyle) -> VisualPart {
        var numv = num.build(withStyle: style)
        var denv = den.build(withStyle: style)
        let nf = numv.frame
        let df = denv.frame
        let w = max(nf.width, df.width)
        
        let sp = NSPoint(x: 0, y: 1)
        let ep = NSPoint(x: w, y: 1)
        let lns = ShapeType.Path(points: [sp,ep])
        let font = style.displayFont()
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
    }
    
    static func binomial(ne: MathExpr, ke: MathExpr, withStyle style: VisualStyle) -> VisualPart {
        let n1 = ne.build(withStyle: style)
        let n2 = ke.build(withStyle: style)
        return VisualPart.stack([n1,n2], withStyle: style)
    }
    
    static func mathSequence(exprs: [MathExpr], withStyle style: VisualStyle) -> VisualPart {
        let ve = exprs.map {$0.build(withStyle: style.framed(false))}
        return VisualPart.sequence(ve, withStyle: style)
    }

    static func root(oe: MathExpr?, ex: MathExpr, withStyle style: VisualStyle) -> VisualPart {
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
    }
    
    static func bracketed(lsym: MathBracketSymbol, expr: MathExpr, rsym: MathBracketSymbol, withStyle style: VisualStyle) -> VisualPart {
        let exv = expr.build(withStyle: style)
        let exvf = exv.frame
        let bf = ElementSize(width: 10, height: exvf.height, realWidth: 10, baseline: exvf.baseline, xHeight: exvf.xHeight)
        
        func shape(sym: MathBracketSymbol, ofSize s: ElementSize) -> ShapeType {
            switch sym {
            case .LParen : return MathExpr.leftParen(s)
            case .RParen : return MathExpr.rightParen(s)
            }
        }
        
        let lb = shape(lsym, ofSize: bf)
        let rb = shape(rsym, ofSize: bf)
        let lbv = VisualPart.Shape(type: lb, frame: bf, style: style)
        let rbv = VisualPart.Shape(type: rb, frame: bf, style: style)
        return VisualPart.sequence([lbv,exv,rbv], withStyle: style)
    }

    static func unary(op: String, ex: MathExpr, withStyle style: VisualStyle) -> VisualPart {
        let opv = op.build(withStyle: style)
        let exv = ex.build(withStyle: style)
        return VisualPart.sequence([opv,exv], withStyle: style)
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



