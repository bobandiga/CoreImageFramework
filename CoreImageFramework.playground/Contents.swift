import UIKit
import PlaygroundSupport
import CoreImage
import CoreImage.CIFilterBuiltins
import AVFoundation

let url = Bundle.main.url(forResource: "photoTest", withExtension: "jpeg")!

// 1: Options
let options = [
    CIImageOption.applyOrientationProperty: true
]
let image = CIImage(contentsOf: url, options: options)
//
//2: Filtering

let filter = CIFilter(name: "CIVibrance", parameters: ["inputImage": image, "inputAmount": 0.9])
filter?.outputImage

let filter2 = CIFilter.vibrance()
filter2.amount = 0.9
filter2.inputImage = image
filter2.outputImage

// 3: Filter chains
let filter3 = CIFilter.gloom()
filter3.radius = 10
filter3.intensity = 0.7
filter3.inputImage = filter2.outputImage

let filter4 = CIFilter.vignette()
filter4.radius = 2
filter4.intensity = 0.9
filter4.inputImage = filter3.outputImage

let finishedImage = filter4.outputImage?.cropped(to: image!.extent)

// 4: - UIImage from CIImage
let uiImage = UIImage(ciImage: finishedImage!)
let uiImageView = UIImageView(image: uiImage)
uiImageView.contentMode = .scaleAspectFit

let uiImageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
uiImageView2.contentMode = .scaleAspectFit

let context = CIContext()
let cgImage = context.createCGImage(finishedImage!, from: finishedImage!.extent)
uiImageView2.image = UIImage(cgImage: cgImage!)

PlaygroundPage.current.liveView = uiImageView2

// 5: Output CIImage
let context = CIContext()

let heifURL = URL(fileURLWithPath: ".../output.heif")
try! context.writeHEIFRepresentation(of: finishedImage!, to: heifURL, format: .RGBA8, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, options: [:])

let jpegURL = URL(fileURLWithPath: ".../output.jpeg")
try! context.writeJPEGRepresentation(of: finishedImage!, to: jpegURL, colorSpace: CGColorSpace(name: CGColorSpace.sRGB), options: [:])
