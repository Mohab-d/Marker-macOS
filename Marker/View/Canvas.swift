import Cocoa

// barcode properties
struct BarcodeProperties {
    var barcodeValue: String
    var width: Double
    var height: Double
    var fontSize: Double
    var hasLabel: Bool
    
    init(barcodeValue: String, width: Double, height: Double, fontSize: Double, hasLabel: Bool) {
        self.barcodeValue = barcodeValue
        self.width = width
        self.height = height
        self.fontSize = fontSize
        self.hasLabel = hasLabel
    }
}

class Canvas: NSView {
    let markerController = MarkerController()
    
    // default properties
    var barcodeProperties = BarcodeProperties(barcodeValue: "",
                                              width: 0,
                                              height: 0,
                                              fontSize: 0,
                                              hasLabel: false)
    
    // draw content
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        generateBarcode()
        
    }

    
    // draw barcode
    func generateBarcode() {
        if let ctx: CGContext = NSGraphicsContext.current?.cgContext {
            
            // barcode
            if let barcode = markerController.makeBarcode(value: barcodeProperties.barcodeValue,
                                                          size: CGSize(width: barcodeProperties.width,
                                                                       height: barcodeProperties.height)) {
                let barcodeRect = CGRect(x: (self.bounds.width - barcode.size.width) / 2,
                                         y: (self.bounds.height - barcode.size.height) / 2,
                                         width: barcode.size.width,
                                         height: barcode.size.height)
                
                // text
                if barcodeProperties.hasLabel  && (barcodeProperties.fontSize > 0) {
                    let text = markerController.generateText(txt: barcodeProperties.barcodeValue,
                                                             txtSize: barcodeProperties.fontSize)
                    let textXPosition = (self.bounds.width - text.size().width) / 2
                    let textYPosition = (barcodeRect.origin.y + (barcodeProperties.height / 5.3)) - text.size().height
                    
                    let textRect = NSRect(origin: CGPoint(x: textXPosition,
                                                          y: textYPosition),
                                          size: text.size())
                    ctx.setTextDrawingMode(.fill)
                    
                    let textHeight = text.size().height
                    let textWidth = text.size().width
                    print(textHeight)
                    print(textWidth)
                    
                    // white rectangle
                    let rectWidth: Double
                    if text.size().width > barcodeProperties.width {
                        rectWidth = text.size().width
                    } else {
                        rectWidth = barcode.size.width
                    }
                    
                    let whiteRect = CGRect(origin: CGPoint(x: barcodeRect.origin.x,
                                                           y: textYPosition),
                                           size: CGSize(width: rectWidth,
                                                        height: barcodeProperties.height))
                    
                    ctx.setFillColor(CGColor.white)
                    ctx.addRect(whiteRect)
                    
                    // start drawing
                    ctx.drawPath(using: CGPathDrawingMode.fill)
                    barcode.draw(in: barcodeRect)
                    text.draw(in: textRect)
                } else {
                    barcode.draw(in: barcodeRect)
                }
            }
        }
    }
}
