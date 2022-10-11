import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var barcodeView: Canvas!
    @IBOutlet weak var userInput: NSTextField!
    @IBOutlet weak var amount: NSTextField!
    @IBOutlet weak var onlyNumbersBox: NSButton!
    @IBOutlet weak var userWidth: NSTextField!
    @IBOutlet weak var userHeight: NSTextField!
    @IBOutlet weak var inputErrorMessege: NSTextField!
    @IBOutlet weak var selectedFontSize: NSPopUpButton!
    @IBOutlet weak var generateRandomChecked: NSButton!
    @IBOutlet weak var showValueChecked: NSButton!
    @IBOutlet weak var numberOfDigits: NSTextField!
    @IBOutlet weak var randomBarcodesTable: NSTableView!
    
    
    let markerController = MarkerController()
    var randomGeneratedBarcodes: [Int]?
    
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
        // clear errors
        inputErrorMessege.cell?.title = ""
        
        // generate barcode from user input
        if generateRandomChecked.state == NSControl.StateValue.off {
            if userInput.cell?.title == "" {
                inputErrorMessege.cell?.title = "Please insert a barcode value"
                return
            }
            redrawView()
        }
        
        // generate barcode automatically <--- fix security
        if onlyNumbersBox.state == NSControl.StateValue.on {
            randomGeneratedBarcodes = generateRandomInt(numberOfDigits: Int(numberOfDigits.cell!.title)!,
                              amount: Int(amount.cell!.title)!)
            print(randomGeneratedBarcodes!)
        }
    }
    
    @IBAction func saveBarcodes(_ sender: NSButton) {
    }
    
    // MARK: - Functions
    // generate random barcode
    func generateRandomInt(numberOfDigits: Int, amount: Int) -> [Int] {
        var counter: Int = 0
        var generatedNumber: Int = 0
        var generatedNumbersArray: [Int] = []
        
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
        while counter < amount {
            generatedNumber = Int.random(in: minValue...maxValue)
            generatedNumbersArray.append(generatedNumber)
            counter += 1
        }
        return generatedNumbersArray
    }
    
    // draw barcode
    func redrawView() {
        
        // check if inputs are nil
        if userWidth.cell?.title == "" {
            inputErrorMessege.cell?.title = "Please insert width value"
            return
        }
        if userHeight.cell?.title == "" {
            inputErrorMessege.cell?.title = "Please insert a height value"
            return
        }
        
        // invalid characters set
        let invalidCharacters = NSCharacterSet(charactersIn:".0123456789").inverted
        
        // delet spaces from inputs
        let width = markerController.filterString(invalidCharacters: invalidCharacters,
                                                  string: userWidth.cell!.title,
                                                  replacement: "")
        let height = markerController.filterString(invalidCharacters: invalidCharacters,
                                                   string: userHeight.cell!.title,
                                                   replacement: "")
        
        /*
         At this stage the inputs are completley filterd.
         So the only non-safe remaining is if the user provided a period without numbers or provided spaces only,
         since 'filterString' function will delet spaces the inputs with spaces only will be empty,
         and inputs with one period will pass all the tests only to crash later 
         */
        
        // check if inputs are usable values
        if width == "" || width == "." {
            inputErrorMessege.cell?.title = "Please insert a width value"
            return
        }
        if height == "" || height == "." {
            inputErrorMessege.cell?.title = "Please insert a height value"
            return
        }
        
        // correct user input
        userWidth.cell?.title = width
        userHeight.cell?.title = height
        
        // check if string contains more than one period
        if markerController.periodCounter(string: width) > 1 {
            inputErrorMessege.cell?.title = "Invalid width, contains more than one period"
            return
        }
        if markerController.periodCounter(string: height) > 1 {
            inputErrorMessege.cell?.title = "Invalid height, contains more than one period"
            return
        }
        
        // convert inputs from cm to pixels
        let computedWidth = Double(width)! * 37.795275591
        let computedHeight = Double(height)! * 37.795275591
        
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
        
        // start drawing if conditions are passed
        if barcodeView.checkConditions(label: inputErrorMessege) {
            barcodeView.needsDisplay = true
        }
    }
}

// MARK: - Table view data source
extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return randomGeneratedBarcodes?.count ?? 0
    }
}


// MARK: - Table view delegate

extension ViewController: NSTableViewDelegate {
    
}
