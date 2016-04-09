//
//  VisualDomain.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 09/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Foundation

/// Capture the size characteristics of a Visual Element
struct ElementSize {
    let width       : CGFloat
    let height      : CGFloat
    let realWidth   : CGFloat
    let baseline    : CGFloat
    let xHeight     : CGFloat
}

/// Visual style elements
struct VisualStyle {
    let fontSize : CGFloat
}

/// The set of elements which can be rendered
indirect enum VisualPart {
    case Text(t: String, frame: ElementSize, style: VisualStyle)
}

/// Protocol for domain types which can be visualised.
protocol VisualPartCreator {
    func build(withStyle style: VisualStyle) -> VisualPart
}

