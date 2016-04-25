//: Playground - noun: a place where people can play

import Cocoa

let fm = NSFontManager.sharedFontManager()
let families = fm.availableFontFamilies

extension String {
    func size(withAttributes attrs: [String:AnyObject], constrainedTo box: NSSize, padding: CGFloat = 0.0) -> NSSize {
        let storage = NSTextStorage(string: self)
        let container = NSTextContainer(containerSize: NSSize(width: box.width, height: box.height))
        let layout = NSLayoutManager()
        layout.addTextContainer(container)
        storage.addLayoutManager(layout)
        storage.addAttributes(attrs, range: NSMakeRange(0, storage.length))
        container.lineFragmentPadding = padding
        let gr = layout.glyphRangeForTextContainer(container)
        let ur = layout.usedRectForTextContainer(container)
        let br = layout.boundingRectForGlyphRange(gr, inTextContainer: container)
        
        return NSSize(width: br.width, height: br.height)
    }
}

func displayFont(fontSize: CGFloat, italic: Bool, bold: Bool) -> NSFont {
    var traits : NSFontTraitMask = NSFontTraitMask()
    if italic {
        traits.insert(NSFontTraitMask.ItalicFontMask)
    }
    
    if bold {
        traits.insert(NSFontTraitMask.BoldFontMask)
    }
    
    let fm = NSFontManager.sharedFontManager()
    if let fnt = fm.fontWithFamily("Times New Roman", traits: traits, weight: 1, size: fontSize) {
        return fnt
    }
    
    return NSFont.systemFontOfSize(fontSize)
}


let f1 = displayFont(24, italic: false, bold: false)
let f2 = displayFont(24, italic: true, bold: false)

let s1 = "faf".size(withAttributes: [NSFontAttributeName:f1], constrainedTo: NSSize(width: 1000, height: 1000))
let s2 = "faf".size(withAttributes: [NSFontAttributeName:f2], constrainedTo: NSSize(width: 1000, height: 1000))

print(s1)
print(s2)
