# Cocoa Text Attachment Cells

This project works through an example Cocoa project which creates ***NSTextAttachment*** cells which can be embedded within *attributed text views*. Whilst aimed at *OS X* Cocoa based applications the techniques presented here are equally applicable (in most places) to *iOS* apps.




## Creating Basic Attachments

Before we can get into producing any interesting code we need to setup the basic framework for displaying attributed text and showing a simple *cell*.   


For the purposes of this post we're going to create images to represent cell content, so the first step we need to do is create a test image for our cell. The easiest way to do this in Cocoa *(but not in UIKit)* is through the *NSImage* initialiser which takes a closure in which you can provide any drawing commands for the image.    

At this stage we can simply draw a filled box so we can see the impact clearly on the eventual attributed rendering.   
### Creating Test Image
 
	let img = NSImage(size: s, flipped: false) { (r) -> Bool in
            let p = NSBezierPath(rect: r)
            NSColor.greenColor().setFill()
            p.fill()
            return true
        }

### Creating Attachment Cell
Now we've got the ability to draw the cell content we can complete the *NSTextAttachmentCell* implementation - simply initialise with a size, create the test image with that size and call the superclass initialiser with that test image.

*We'll need to come back and change bits in this class a little later on*



	class TextDisplayCell : NSTextAttachmentCell {
    	var size : NSSize
        
        init(withSize s: NSSize) {
            self.size = s
            
            let img = NSImage(size: s, flipped: false) { (r) -> Bool in
                let p = NSBezierPath(rect: r)
                NSColor.greenColor().setFill()
                p.fill()
                return true
            }
            
            super.init(imageCell: img)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func cellSize() -> NSSize {
            return size
        }   
	}

### Displaying the Attachment

Creating something which can be inserted into the editor view is now a simple matter of wrapping a cell of a specified size in an *NSTextAttachment* and then wrapping that within an *NSAttributedString*.

	let inline = TextDisplayCell(withSize: NSSize(width: 100, height: 34))
    let cell = NSTextAttachment()
    cell.attachmentCell = inline
    let cellstr = NSAttributedString(attachment: cell)

The full content of our View Controller now looks like the following - *note that the cellstr is inserted into the text storage element of the NSTextView instance*

    class ViewController: NSViewController {
        @IBOutlet var editor: NSTextView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
    
            let inline = TextDisplayCell(withSize: NSSize(width: 100, height: 34))
            let cell = NSTextAttachment()
            cell.attachmentCell = inline
            let cellstr = NSAttributedString(attachment: cell)
            
            editor.textStorage?.replaceCharactersInRange(NSRange(location: 3, length: 0), withAttributedString: cellstr)
        }
    
    }

If you build and run the application at this stage you should see output like the following: -


![Basic Cell Screenshot](https://github.com/plumhead/CocoaTextAttachmentCells/BasicCellDisplay.png).




















