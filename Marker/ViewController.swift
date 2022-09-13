//
//  ViewController.swift
//  Marker
//
//  Created by IMac on 05/09/2022.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var barcodeView: Canvas!
    @IBOutlet weak var userInput: NSTextField!
    @IBOutlet weak var userAmount: NSStackView!
    @IBOutlet weak var onlyNumbersBox: NSButton!
    @IBOutlet weak var generatedBarcodesTable: NSScrollView!
    @IBOutlet weak var userWidth: NSTextField!
    @IBOutlet weak var userHeight: NSTextField!
    
    let markerController = MarkerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        barcodeView.draw(NSRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 50)))
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func GenerateRandomBarcode(_ sender: NSButton) {
        
        // convert width and height to pixels
        let computedWidth: Double? = Double((userWidth.cell?.title ?? "0"))! * 0.0264583333
        let computedHeight: Double? = Double((userHeight.cell?.title ?? "0"))! * 0.0264583333
        
        if computedWidth != nil && computedHeight != nil {
            barcodeView.draw(NSRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: computedWidth!, height: computedHeight!)))
        }
        
    }
    
    @IBAction func saveBarcodes(_ sender: NSButton) {
    }
}
