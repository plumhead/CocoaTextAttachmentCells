//
//  Extensions.swift
//  CocoaTextAttachmentCells
//
//  Created by Plumhead on 17/04/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import Foundation

extension Array {
    func intersperse(e : Element) -> [Element] {
        return self.reduce([]) { (a, p) -> [Element] in
            guard !a.isEmpty else {return [p]}
            return a + [e,p]
        }
    }
}


func +(l: NSPoint, r: NSPoint) -> NSPoint {
    return NSPoint(x: l.x + r.x, y: l.y + r.y)
}