import Cocoa

class ViewController: NSViewController {
    
    // outlets
    @IBOutlet weak var userInput: NSTextField!
    @IBOutlet weak var amount: NSTextField!
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
        selectedFontSize.isEnabled = false
        amount.isEnabled = false
        length.isEnabled = false
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
            length.isEnabled = true
            userInput.isEnabled = false
            return
        }
        userInput.isEnabled = true
        amount.isEnabled = false
        length.isEnabled = false
    }
    
    @IBAction func showValuePressed(_ sender: NSButton) {
        if showValueChecked.state == NSControl.StateValue.on {
            selectedFontSize.isEnabled = true
            return
        }
        selectedFontSize.isEnabled = false
    }
    
    @IBAction func saveBarcodes(_ sender: NSButton) {
        // clear errors
        inputErrorMessege.stringValue = ""
        
        // auto generate barcode and save it

        /*
         conditions to check:
         amount and lenght are only integers
         numbers only box is checked
         amount have maximum of 100
         lenght have maximum of 70 character
         methode:
         show save panel to make user choose location
         take location url from save panel object
         name each barcode accourding to it's value
         save barcodes
         */
        
        if generateRandomChecked.state == NSControl.StateValue.on {
            
            
            // check if amount and lenght are nil
            if amount.cell?.title == "" {
                inputErrorMessege.cell?.title = "Please provide an amount"
                return
            }
            if length.cell?.title == "" {
                inputErrorMessege.cell?.title = "Please provide a lenght"
                return
            }
            
            //check if amount and lenght are Int
            let amountIsInt = markerController.isInteger(input: amount)
            let lenghtIsInt = markerController.isInteger(input: length)
            
            // check if amount and lenght exceed their limits
            if amountIsInt && lenghtIsInt {
                if Int(amount.cell!.title)! > 100 {
                    inputErrorMessege.cell?.title = "Maximum amount per one time is 100"
                    return
                }
                if Int(length.cell!.title)! > 70 {
                    inputErrorMessege.cell?.title = "Maximum length is 70"
                }
                
                //-- after all tests passed start auto generation
                // get location from save panel
                markerController.generateRandomBarcodesAndSaveThem(amount: Int(amount.cell!.title)!,
                                                                   length: Int(length.cell!.title)!,
                                                                   userWidth: userWidth,
                                                                   userHeight: userHeight,
                                                                   inputErrorMessege: inputErrorMessege,
                                                                   showValueChecked: showValueChecked,
                                                                   selectedFontSize: selectedFontSize)
            }
            return
        }
        
        // save manually generated barocdes
        if userInput.cell?.title != "" {
            let barcode = markerController.creatBarcode(barcodeValue: userInput.cell!.title,
                                                        userWidth: userWidth,
                                                        userHeight: userHeight,
                                                        inputErrorMessege: inputErrorMessege,
                                                        showValueChecked: showValueChecked,
                                                        selectedFontSize: selectedFontSize)!
            
            markerController.showSavePanel(img: barcode)
            return
        }
        inputErrorMessege.cell?.title = "Please provide a barcode value"
        return
    }
}
/*
 let url: URL = URL(string: "file:///Users/imac/Desktop/randomGeneratedBarcodes/\(2).png")!
 markerController.savePNG(image: barcodeImage, path: url)
 */
