import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var barcodeView: Canvas!
    @IBOutlet weak var userInput: NSTextField!
    @IBOutlet weak var userAmount: NSStackView!
    @IBOutlet weak var onlyNumbersBox: NSButton!
    @IBOutlet weak var generatedBarcodesTable: NSScrollView!
    @IBOutlet weak var userWidth: NSTextField!
    @IBOutlet weak var userHeight: NSTextField!
    @IBOutlet weak var inputErrorMessege: NSTextField!
    @IBOutlet weak var selectedFontSize: NSPopUpButton!
    
    let markerController = MarkerController()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
    @IBAction func GenerateRandomBarcode(_ sender: NSButton) {
        
        let computedWidth =  Double(userWidth.cell!.title)!
        let computedHeight =  Double(userHeight.cell!.title)!
        
        let barcode = BarcodePropeties(barcodeValue: userInput.cell!.title,
                                       width: computedWidth,
                                       height: computedHeight,
                                       textSize: selectedFontSize.doubleValue,
                                       hasLabel: true)
//        barcodeView.checkConditions() <--- working on it
        barcodeView.barcodeProperties = barcode
        barcodeView.needsDisplay = true
    }
    
    @IBAction func saveBarcodes(_ sender: NSButton) {
    }
}

