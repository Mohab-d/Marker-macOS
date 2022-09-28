import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var barcodeView: Canvas!
    @IBOutlet weak var userInput: NSTextField!
    @IBOutlet weak var amount: NSTextField!
    @IBOutlet weak var onlyNumbersBox: NSButton!
    @IBOutlet weak var generatedBarcodesTable: NSScrollView!
    @IBOutlet weak var userWidth: NSTextField!
    @IBOutlet weak var userHeight: NSTextField!
    @IBOutlet weak var inputErrorMessege: NSTextField!
    @IBOutlet weak var selectedFontSize: NSPopUpButton!
    @IBOutlet weak var generateRandomChecked: NSButton!
    @IBOutlet weak var showValueChecked: NSButton!  
    @IBOutlet weak var numberOfDigits: NSTextField!
    
    
    let markerController = MarkerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amount.isEnabled = false
        onlyNumbersBox.isEnabled = false
        selectedFontSize.isEnabled = false
        selectedFontSize.removeAllItems()
        selectedFontSize.addItems(withTitles: ["Font size", "6", "8", "10", "12", "14", "16", "18",
                                               "20", "22", "24", "26", "28", "30", "32", "34", "36"])
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
    // enable or disable the generate random section
    @IBAction func generateRandomPressed(_ sender: NSButton) {
        if generateRandomChecked.state == NSControl.StateValue.on {
            amount.isEnabled = true
            onlyNumbersBox.isEnabled = true
            userInput.isEnabled = false
            return
        }
        userInput.isEnabled = true
        amount.isEnabled = false
        onlyNumbersBox.isEnabled = false
    }
    
    @IBAction func showValuePressed(_ sender: NSButton) {
        if showValueChecked.state == NSControl.StateValue.on {
            selectedFontSize.isEnabled = true
            return
        }
        selectedFontSize.isEnabled = false
    }
    
    @IBAction func fontSizePressed(_ sender: NSPopUpButton) {
        redrawView()
    }
    
    @IBAction func GenerateRandomBarcode(_ sender: NSButton) {
        redrawView()
        generateRandom()
    }
    
    @IBAction func saveBarcodes(_ sender: NSButton) {
    }
    
    // generate random barcode
    func generateRandom() {
        if onlyNumbersBox.state == NSControl.StateValue.on {
            var counter: Int = 0
            
            // calculate minValue <--- explain more
            let minValue: Int = {
                var min = "1"
                var counter = 0
                while counter < Int(numberOfDigits.stringValue)! - 1 {
                    min += "0"
                    counter += 1
                }
                return Int(min)!
            }()
            
            // calculate maxValue <--- explain more
            var maxValue: Int {
                var max = ""
                var counter = 0
                while counter < Int(numberOfDigits.stringValue)! {
                    max += "9"
                    counter += 1
                }
                return Int(max)!
            }
            
            // creat the random barcode
            if let amount = Int(amount.stringValue) {
                while counter < amount {
                    let n = Int.random(in: minValue...maxValue)
                    counter += 1
                }
            }
        }
    }
    
    // redraw view to adopt changes
    func redrawView() {
        // convert user input from cm to pixels
        if userInput.stringValue == "" {
            inputErrorMessege.stringValue = "Please insert a value in the insert box"
            return
        }
        
        let invalidInput: Bool = {
            let decimalCharacters = CharacterSet.decimalDigits
            let decimalRangeInWidth = userWidth.cell?.title.rangeOfCharacter(from: decimalCharacters)
            let decimalRangeInHight = userHeight.cell?.title.rangeOfCharacter(from: decimalCharacters)
            if decimalRangeInWidth != nil {
                return true // did found numbers
            }
            if decimalRangeInHight != nil {
                return true // did found numbers
            }
            
            // contains numbers only?
            return 
        }()
        
        if userWidth.cell?.title != "" && invalidInput {
            let computedWidth = Double(userWidth.cell!.title)! * 37.795275591
            if userHeight.cell?.title != "" {
                let computedHeight = Double(userHeight.cell!.title)! * 37.795275591
                
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
                    if let computedHeight = userHeight.cell?.stringValue {
                        return Double(computedHeight)! * 0.2
                    }
                    inputErrorMessege.stringValue = "An unknown error occured"
                    return 0.0
                }()
                
                // creat barcode object
                let barcode = BarcodePropeties(barcodeValue: userInput.cell!.title,
                                               width: computedWidth,
                                               height: computedHeight,
                                               textSize: fontSize,
                                               hasLabel: isReadable)
                
                // set the barcode properties to the new barcode
                barcodeView.barcodeProperties = barcode
                
                // start redrawing if conditions are passed
                if barcodeView.checkConditions(label: inputErrorMessege) {
                    barcodeView.needsDisplay = true
                }
            } else if !invalidInput {
                inputErrorMessege.stringValue = "Width and Height can only accept numbers"
                print("Width and Height can only accept numbers")
                return
            } else {
                inputErrorMessege.stringValue = "Please insert a height value"
                return
            }
        } else {
            inputErrorMessege.stringValue = "Please insert a width value"
            return
        }
    }
}

