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
    
    //NOT USED AT ALL
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
    
    // delet spaces from a string
    func deletSpaces(string: String) -> String {
        let invalidCharactersInString = string.components(separatedBy: " ")
        let filteredString = invalidCharactersInString.joined(separator: "")
        return filteredString
    }
    
    // NOT USED AT ALL
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
    
    // check width and height inputs validity
    /// Checks if given width and height are valid according to the given set
    ///
    /// The user inputs may cause a crash if they provided nothing, a space, a one period, multiple periods, a negative number or any letter so this function will check all that given back true if the inputs were valid and false otherwise.
    ///
    /// - Parameters:
    ///     - inputErrorMessege: Takes a label in which to write the error decription to the user
    ///     - userWidth: A text field which contains the value of the width
    ///     - userHeight: A text field which contains the value of the height
    ///     - invalidCharacters: A set of invalid characters
    ///
    /// - Returns: A boolean value indicating if inputs were valid
    func dimensionsValidity(errorLabel inputErrorMessege: NSTextField, width userWidth: NSTextField, height userHeight: NSTextField, invalidCharacters: CharacterSet) -> Bool {
        // check if inputs are nil
        if userWidth.cell!.title.isEmpty {
            inputErrorMessege.cell?.title = "Please insert width value"
            return false
        }
        if userHeight.cell!.title.isEmpty {
            inputErrorMessege.cell?.title = "Please insert a height value"
            return false
        }
        
        // delet spaces from inputs
        let width = filterString(invalidCharacters: invalidCharacters,
                                 string: userWidth.cell!.title,
                                 replacement: "")
        let height = filterString(invalidCharacters: invalidCharacters,
                                  string: userHeight.cell!.title,
                                  replacement: "")
        
        /*
         At this stage the inputs are completley filterd.
         So the only non-safe remaining is if the user provided a period without numbers or provided spaces only,
         since 'filterString' function will delet spaces the inputs with spaces only will be empty,
         and inputs with one period will pass all the tests only to crash later
         */
        
        // check if inputs are usable values
        if width.isEmpty || width == "." {
            inputErrorMessege.cell?.title = "Please insert a width value"
            return false
        }
        if height.isEmpty || height == "." {
            inputErrorMessege.cell?.title = "Please insert a height value"
            return false
        }
        
        // correct user input
        userWidth.cell?.title = width
        userHeight.cell?.title = height
        
        // check if string contains more than one period
        if periodCounter(string: width) > 1 {
            inputErrorMessege.cell?.title = "Invalid width, contains more than one period"
            return false
        }
        if periodCounter(string: height) > 1 {
            inputErrorMessege.cell?.title = "Invalid height, contains more than one period"
            return false
        }
        return true
    }
    
    // generate random barcode
    func generateRandomInt(numberOfDigits: Int) -> String {
        
        // calculate minValue <--- explain more
        let minValue: Int = {
            var min = "1"
            var counter = 0
            while counter < numberOfDigits - 1 {
                min += "0"
                counter += 1
            }
            return Int(min)!
        }()
        
        // calculate maxValue <--- explain more
        var maxValue: Int {
            var max = ""
            var counter = 0
            while counter < numberOfDigits {
                max += "9"
                counter += 1
            }
            return Int(max)!
        }
        
        // creat the random barcode
        return String(Int.random(in: minValue...maxValue))
    }
    
    //    // generate random string
    //    func randomString(length: Int) -> String {
    //        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    //        let string = letters.random
    //        // String((0..<length).map{ _ in letters.randomElement()! })
    //    }
    
    // get NSImage from a NSView
    func convertToImage(view: NSView) -> NSImage {
        let rep = view.bitmapImageRepForCachingDisplay(in: view.bounds)!
        view.cacheDisplay(in: view.bounds, to: rep)
        let image: NSImage = NSImage()
        image.addRepresentation(rep)
        return image
    }
    
    // save img to disk
    func savePNG(image: NSImage, path: URL) {
        let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
        let pngData = imageRep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
        do {
            try pngData?.write(to: path)
        } catch {
            print(error)
        }
    }
    
    // build save panel
    func buildSavePanel() -> NSSavePanel {
        let savePanel = NSSavePanel()
        savePanel.title = "Save barcode"
        savePanel.allowedFileTypes = ["png"]
        return savePanel
    }
    
    // show the save panel
    func showSavePanel(img: NSImage) {
        let savePanel = buildSavePanel()
        savePanel.begin { (result: NSApplication.ModalResponse) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let panelURL = savePanel.url {
                    // creat barcodes to save
                    savePNG(image: img, path: panelURL)
                }
            }
        }
    }
    
    // generate random barcodes and save them
    func generateRandomBarcodesAndSaveThem(amount: Int, length: Int, userWidth: NSTextField, userHeight: NSTextField, inputErrorMessege: NSTextField, showValueChecked: NSButton, selectedFontSize: NSPopUpButton) {
        let savePanel = buildSavePanel()
        savePanel.begin { (result: NSApplication.ModalResponse) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let panelURL = savePanel.directoryURL {
                    // creat barcodes to save
                    var counter = 0
                    while counter < amount {
                        let randomBarcodeValue = generateRandomInt(numberOfDigits: length)
                        let barcode = creatBarcode(barcodeValue: randomBarcodeValue,
                                                   userWidth: userWidth,
                                                   userHeight: userHeight,
                                                   inputErrorMessege: inputErrorMessege,
                                                   showValueChecked: showValueChecked,
                                                   selectedFontSize: selectedFontSize)!
                        let url = "\(panelURL)/\(randomBarcodeValue).png"
                        let savingPath: URL = URL(string: url)!
                        savePNG(image: barcode, path: savingPath)
                        counter += 1
                    }
                }
            }
        }
    }
    
    // check if a number is integer
    func isInteger(input: NSTextField) -> Bool {
        Int(input.cell!.title) != nil ? true: false
    }
    
    // check the manualy provided barcode value validity
    /// Checks if manual input is valid
    ///
    /// - Parameters:
    ///     - errorLabel: a label in which to write the error messege
    ///
    /// - Returns: return true if inpu is valid
    func checkManualBarcodeValue(manualInput: String, errorLabel: NSTextField) -> Bool {
        if manualInput.isEmpty {
            errorLabel.stringValue = "Please insert barcode value"
            return false
        }
        
        let characterset = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-")
        if manualInput.rangeOfCharacter(from: characterset.inverted) != nil {
            errorLabel.stringValue = "Should only contains A to Z, -"
            return false
        }
        
        if manualInput.count > 70 {
            errorLabel.stringValue = "Limit is 70 characters"
            return false
        }
        return true
    }
    
    func creatBarcode(barcodeValue: String, userWidth: NSTextField, userHeight: NSTextField, inputErrorMessege: NSTextField, showValueChecked: NSButton, selectedFontSize: NSPopUpButton) -> NSImage? {
        // invalid characters set
        let invalidCharacters = NSCharacterSet(charactersIn:".0123456789").inverted
        
        // check inputs to start generating
        let dimensionsAreValid = dimensionsValidity(errorLabel: inputErrorMessege,
                                                                     width: userWidth,
                                                                     height: userHeight,
                                                                     invalidCharacters: invalidCharacters)
        if dimensionsAreValid {
            // convert dimensions
            let width = Double(userWidth.cell!.title)! * 28.35
            let height = Double(userHeight.cell!.title)! * 28.35
            
            // check if user want to show the barcode value
            let isReadable: Bool = {
                if showValueChecked.state == NSControl.StateValue.on {
                    return true
                }
                return false
            }()
            
            // user's selected font size
            let fontSize: Double = {
                if selectedFontSize.title != "Font size" {
                    return Double(selectedFontSize.title)!
                }
                return 0.0
            }()
            
            // set barcode properties
            let barcodeProperties = BarcodeProperties(barcodeValue: barcodeValue,
                                                      width: width,
                                                      height: height,
                                                      fontSize: fontSize,
                                                      hasLabel: isReadable)
            
            // creat NSView to draw barcode in
            let canvas = Canvas(frame: NSRect(origin: .zero, size: CGSize(width: width,
                                                                          height: height)))
            
            // if text is out of frame change frame size
            canvas.frame.size.height += (Double(barcodeProperties.fontSize) * 1.33)
            // draw barcode
            canvas.barcodeProperties = barcodeProperties
            canvas.needsDisplay = true
            
            return convertToImage(view: canvas)
        }
        return nil
    }
}

