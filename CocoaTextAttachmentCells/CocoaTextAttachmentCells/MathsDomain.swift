//
//  MathsDomain.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 24/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Foundation

public enum MathBracketSymbol {
    case LParen
    case RParen
    case LBracket
    case RBracket
    case LBrace
    case RBrace
}

public enum MathSymbol {
    case Sum
}


public indirect enum MathExpr {
    case Text(text: String)
    case Integer(int : Int)
    case Number(num : Double)
    case Symbol(sym: MathSymbol)
    case Operator(lexpr : MathExpr, op: String, rexpr: MathExpr)
    case Unary(op: String, expr: MathExpr)
    case Sequence(exprs: [MathExpr])
    case Fraction(numerator: MathExpr, denominator: MathExpr)
    case Binomial(n: MathExpr, k: MathExpr)
    case Bracketed(left: MathBracketSymbol, expr: MathExpr, right: MathBracketSymbol)
    case Root(order: MathExpr?, expr: MathExpr)
    case Node(expr: MathExpr, sub : MathExpr?, sup: MathExpr?)
}



