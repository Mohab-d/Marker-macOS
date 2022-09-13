//
//  Canvas.swift
//  Marker
//
//  Created by IMac on 09/09/2022.
//

import Cocoa

class Canvas: NSView {
    let markerCotroller = MarkerController()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        if let ctx: CGContext = NSGraphicsContext.current?.cgContext {
            // draw barcode
            let barcode = markerCotroller.CGBarcode(value: "12345678901", size: CGSize(width: 400, height: 200))
            let barcodeRect = CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 400, height: 200))
            barcode?.draw(in: barcodeRect)
            
            // draw text
            let text = markerCotroller.generateText(txt: "12345678901")
            let textRect = NSRect(origin: CGPoint(x: 100, y: -60), size: CGSize(width: 400, height: 200))
            ctx.setTextDrawingMode(.fill)
            text.draw(in: textRect)
        }
    }
}
