import Cocoa

// barcode properties
struct BarcodePropeties {
    var barcodeValue: String
    var width: Double
    var height: Double
    var textSize: Double
    var hasLabel: Bool
    
    init(barcodeValue: String, width: Double, height: Double, textSize: Double, hasLabel: Bool) {
        self.barcodeValue = barcodeValue
        self.width = width
        self.height = height
        self.textSize = textSize
        self.hasLabel = hasLabel
    }
}

class Canvas: NSView {
    let markerController = MarkerController()
    
    // default properties
    var barcodeProperties = BarcodePropeties(barcodeValue: "Welcome",
                                             width: 625,
                                             height: 477,
                                             textSize: 80,
                                             hasLabel: true)
    
    // values to calculate position
    var drawingArea: CGSize = CGSize(width: 0.0, height: 0.0)
    var barcodeXPosition: Double = 0.0
    var barcodeYPosition: Double = 0.0
    var textYPosition: Double = 0.0
    var textXPosition: Double = 0.0
    
    // draw content
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        drawingArea.width = dirtyRect.width
        drawingArea.height = dirtyRect.height
        generateBarcode()
    }
    
    // draw barcode
    /// Generates a barcode with text under based on `barcodeProperties`
    func generateBarcode() {
        if let ctx: CGContext = NSGraphicsContext.current?.cgContext {
            
            // barcode
            if let barcode = markerController.makeBarcode(value: barcodeProperties.barcodeValue,
                                                        size: CGSize(width: barcodeProperties.width,
                                                                     height: barcodeProperties.height)) {
                barcodeXPosition = (drawingArea.width - barcodeProperties.width) / 2
                barcodeYPosition = (drawingArea.height - barcodeProperties.height) / 2
                let barcodeRect = CGRect(origin: CGPoint(x: barcodeXPosition,
                                                         y: barcodeYPosition),
                                         size: barcode.size)
                barcode.draw(in: barcodeRect)
                
                // text
                if barcodeProperties.hasLabel {
                    let text = markerController.generateText(txt: barcodeProperties.barcodeValue,
                                                             txtSize: barcodeProperties.textSize)
                    textXPosition = (drawingArea.width - text.size().width) / 2
                    textYPosition = (barcodeYPosition + (barcodeProperties.height / 5)) - text.size().height
                    
                    let textRect = NSRect(origin: CGPoint(x: textXPosition,
                                                          y: textYPosition),
                                          size: text.size())
                    ctx.setTextDrawingMode(.fill)
                    text.draw(in: textRect)
                }
            }
        }
    }
    
    // check conditions <-- fix the small bugs
    /// Checks if given properties are allowed
    ///
    /// - Parameters:
    ///     - label: a label in which to write the error messege
    ///
    /// - Returns: a bool to make sure all conditions were applyed
    func checkConditions(label: NSTextField) -> Bool {
        let characterset = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-")
        if barcodeProperties.barcodeValue.rangeOfCharacter(from: characterset.inverted) != nil {
            label.stringValue = "Should only contains Aa -> Zz, -"
            return false
        }
        if barcodeProperties.barcodeValue.count > 70 {
            label.stringValue = "Limit is 70 characters"
            return false
        }
        if barcodeProperties.width > drawingArea.width {
            barcodeProperties.width = 625.0
            label.stringValue = "The barcode you made is bigger than the view area so Marker minimized it but it will have your selected size upon saving (Max width = 625, Max height = 477)"
            return false
        }
        if barcodeProperties.height > drawingArea.height {
            barcodeProperties.height = 477.0
            label.stringValue = "The barcode you made is bigger than the view area so Marker minimized it but it will have your selected size upon saving (Max width = 625, Max height = 477)"
            return false
        }
        
        label.stringValue = ""
        return true
    }
}

