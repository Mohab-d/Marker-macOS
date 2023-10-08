# Marker-macOS
### Video Demo:  https://youtu.be/XFhOsGJZ0tk

Hello!  
This is CS50's final project by Mohammad Mohab (me XD).  

So marker is a macOS app that can generate barcodes either manually or automatically.  

## Manual generation:  
Manual generation is by handing an input to marker which can be a combination of characters, numbers and a dash!, And you can still specify the width and height of the barcode.  

### Both the manual and auto generations can be specified the width and the height of the barcode and can be made to be human readable by showing a lable  
of the barcode value underneeth the barcode itself and the font size of that lable can be specified!.  

## Automatic generation:
Automatic generation is by specifing an amount and a length of the generated value, then specify the size and font settings, hit save wich shows  
a save panel to choose the saving location then marker would save all generated barcodes to the specified location each of which is named as the value of the barcode itself.  

## Extras:
So this was how marker works, no let's talk a bit technical:  

### Canvas
So marker have canvas which is a NSView file that contains all the code resposible for drawing the barcode to a view called NSView using the functions from anouther file called MarkerController.  
Canvas is a special NSView because it's made with love, i made canvas to be usable, it has a struct called BarcodeProperties which you use to get back a barcode object containing the image generated for that barcode.  

### MarkerController
This struct is the brain of marker, this is where all the magic happens, in this struct you will see the functions that creats the barcode using the CFFilters and the CGContexts, then you see the function responsible to show the saving panel, the function that generates a random integers to use in the automatic generation process, you will see a func like filterString which delet any thing unwanted in the provided string which is specified as an invalidset a data type specified in the swift language it self.  
Continue to see functions like periodeCounter which is a function used to count the periods in the given string, i use it to see if the user provided only a periode in the text fields or provided a width and height value but gave 2 periods by accident so this actually prevents marker from crashing like dimensionsValidity function.  
You can see a that there are a lot of functions in marker are only designed to prevent crashes to povide a good user expirience and to be usable anywhere for my future apps.  
and you might see some functions thare weren't used at all and these are some futures that i wanted to include in future updates.  

### ViewController
This is simply the file that handles what the user see and where they can provide us with the inputs to do what they want, marker is an app made base on story board wich uses IBOutlets and IBActions to do the jop, story board is old but it's more beginner friendly than swiftUI.
## This was mohammad from marker and this is cs50.  
