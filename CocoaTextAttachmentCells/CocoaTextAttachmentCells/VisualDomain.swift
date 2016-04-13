//
//  VisualDomain.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 09/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Cocoa

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


extension ElementSize {
    var size : NSSize {return NSSize(width: self.width, height: self.height)}
}

/// Helper to provide information on visual elements
extension VisualPart {
    static func textSize(forText symbol: String, withFont font: NSFont) -> ElementSize {
        let displaySize = symbol.size(withAttributes: [NSFontAttributeName:font], constrainedTo: NSSize(width: 5000, height: 5000), padding: 0.0)
        let h = max(displaySize.height, font.ascender + fabs(font.descender))
        return ElementSize(width: displaySize.width, height: h, realWidth: displaySize.width, baseline: fabs(font.descender), xHeight: font.xHeight)
    }
    
    var frame : ElementSize {
        switch self {
        case let .Text(_,frame,_) : return frame
        }
    }
}


/// Modify the Visual Styling (simply allow font size change at the moment)
extension VisualStyle {
    // Reduce the fontSize
    var smaller : VisualStyle {
        return VisualStyle(fontSize: self.fontSize > 6 ? self.fontSize - 2 : self.fontSize)
    }
    
    // Increase the fontSize
    var bigger : VisualStyle {
        return VisualStyle(fontSize: self.fontSize + 2)
    }
}