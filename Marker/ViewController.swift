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
    @IBOutlet weak var length: NSTextField!
    
    
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
        if userInput.cell?.title == "" {
            return
        }
        drawToView(barcodeValue: userInput.cell!.title)
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
            drawToView(barcodeValue: userInput.cell!.title)
        }
        
        // generate barcode automatically
        if onlyNumbersBox.state == NSControl.StateValue.on {
            if isInteger(input: amount) && isInteger(input: length){
                for _ in 1...Int(amount.cell!.title)! {
                    //markerController.generateRandomInt(numberOfDigits: Int(length.cell!.title)!)
                }
                return
            }
            inputErrorMessege.cell?.title = "Please insert a valid amount/Length"
        }
    }
    
    @IBAction func saveBarcodes(_ sender: NSButton) {
        let width = userWidth.cell!.title
        let height = userHeight.cell!.title
        if width != "" && height != "" {
            let barcodeImg = markerController.convertToImage(view: barcodeView, imageBounds: NSRect(origin: CGPoint(x: 0,
                                                                                                                    y: 0),
                                                                                                    size: CGSize(width: barcodeView.imgBounds.width,
                                                                                                                 height: barcodeView.imgBounds.height)))
            markerController.showSavePanel(img: barcodeImg)
        }
        return
    }
    
    // MARK: - Functions
    // draw barcode
    func drawToView(barcodeValue: String) {
        // invalid characters set
        let invalidCharacters = NSCharacterSet(charactersIn:".0123456789").inverted
        
        // check if inputs are valid
        if !markerController.dimensionsValidity(errorLabel: inputErrorMessege,
                                                width: userWidth,
                                                height: userHeight,
                                                invalidCharacters: invalidCharacters) {
            return
        }
        
        // delet spaces from inputs
        let width = markerController.filterString(invalidCharacters: invalidCharacters,
                                                  string: userWidth.cell!.title,
                                                  replacement: "")
        let height = markerController.filterString(invalidCharacters: invalidCharacters,
                                                   string: userHeight.cell!.title,
                                                   replacement: "")
        
        // convert inputs from cm to pixels
        let computedWidth = Double(width)! * 28.35
        let computedHeight = Double(height)! * 28.35
        
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
        let barcode = BarcodePropeties(barcodeValue: barcodeValue,
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
    
    /*
     input == int? -> return true
     else return flase
     */
    func isInteger(input: NSTextField) -> Bool {
        Int(input.cell!.title) != nil ? true: false
    }
}
