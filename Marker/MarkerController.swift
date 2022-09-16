import Foundation
import AppKit

struct MarkerController {
    
    //generate barcode
    func CGBarcode(value: String, size: CGSize) -> NSImage? {
        
        // encode inpute
        let userInput = value.data(using: String.Encoding.ascii)
        
        // creat filter
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(userInput, forKey: "inputMessage")
            
            // transforming
            let scaledWidth = size.width / 132
            let scaledHeight = size.height / 52
            let transform = CGAffineTransform(scaleX: scaledWidth, y: scaledHeight)
            
            // creat barcode
            if let output = filter.outputImage?.transformed(by: transform) {
                let ctx = CIContext(options: nil)
                let cgImage = ctx.createCGImage(output, from: output.extent)
                let image = NSImage(cgImage: cgImage!, size: NSSize(width: size.width, height: size.height))
                return image
            }
        }
        return nil
    }
    
    // generate text
    func generateText(txt: String, txtSize: Double) -> NSAttributedString {
        let paragrapghStyle = NSMutableParagraphStyle()
        paragrapghStyle.alignment = .center
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont(name: "Arial", size: txtSize)!,
            .paragraphStyle: paragrapghStyle
        ]
        let attributedString = NSAttributedString(string: txt, attributes: attrs)
        return attributedString
    }
}
