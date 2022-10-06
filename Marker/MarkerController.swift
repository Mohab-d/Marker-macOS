import Foundation
import AppKit

struct MarkerController {
    
    //generate barcode
    /// Makes a barcode from a given value and size
    ///
    ///  - Parameters:
    ///     - value: The value to represent as barcode
    ///     - size: The wanted size for the barcode
    ///
    /// - Returns: An optional NSImage ready to be drawn
    func makeBarcode(value: String, size: CGSize) -> NSImage? {
        
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
    /// Generates the text of the barcode
    ///
    /// - Parameters:
    ///     - txt: the String to draw
    ///     - txtSize: the size of the txt
    /// - Returns: A String ready to be drawn
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
    
    // filters string
    /// Replace characters included in the given set from the given string with the given replacment
    ///
    /// - Parameters:
    ///     - invalidCharacters: a set contains unwanted characters from a string
    ///     - string: A string to filter
    ///     - replacement: A character to replace the unwanted characters in the given set from the given string
    ///
    /// - Returns: A string filtered form characters in the given set
    func filterString(invalidCharacters: CharacterSet, string: String, replacement: String) -> String {
        let invalidCharactersInString = string.components(separatedBy: invalidCharacters)
        let filteredString = invalidCharactersInString.joined(separator: replacement)
        return filteredString
    }
    
    // check if string is valid
    /// Check if string contains unwanted characters accourding to the given set
    ///
    /// - Parameters:
    ///     - invalidCharacters: Unwanted characters
    ///     - String: The string to check
    ///
    /// - Returns: true if the string is invalid
    func invalidString(invalidCahracters: CharacterSet, string: String) -> Bool {
        
        // check if string contains invalid characters
        let range = string.rangeOfCharacter(from: invalidCahracters)
        if range != nil {
            return true
        }
        return false
     }
    
    // counts periods in a string
    /// Counts periods in the given string
    ///
    /// - Returns: Number of period found
    func periodCounter(string: String) -> Int {
        var periodCounter: Int = 0
        for char in string {
            if char == "." {
                periodCounter += 1
            }
        }
        return periodCounter
    }
}
