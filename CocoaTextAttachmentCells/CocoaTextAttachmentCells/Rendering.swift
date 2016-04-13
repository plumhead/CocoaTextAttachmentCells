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
    func render(item i: VisualPartCreator, withStyle style: VisualStyle) -> (RenderType,ElementSize)
    func text(text: String, atPoint p: NSPoint, withStyle style: VisualStyle)
}


protocol VisualElementLayoutHandler {
    func layout(part: VisualPart, x: CGFloat, y: CGFloat, containerSize cs: ElementSize, withStyle style: VisualStyle)
}


extension VisualElementLayoutHandler where Self : VisualElementRenderer {
    func layout(part: VisualPart, x: CGFloat, y: CGFloat, containerSize cs: ElementSize, withStyle style: VisualStyle) {
        switch part {
        case let .Text(t,_,style) :
            text(t, atPoint: NSPoint(x: x, y: y), withStyle: style)
        }
    }
}
