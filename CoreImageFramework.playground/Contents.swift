import UIKit
import PlaygroundSupport
import CoreImage
import CoreImage.CIFilterBuiltins

let url = Bundle.main.url(forResource: "photoTest", withExtension: "jpeg")!

// 1: Options
let options = [
    CIImageOption.applyOrientationProperty: true,
    //CIImageOption.nearestSampling: true
]
let image = CIImage(contentsOf: url, options: options)

// 2: Filtering

//let filter = CIFilter(name: "CIVibrance", parameters: ["inputImage": image, "inputAmount": 0.9])
//filter?.outputImage

let filter = CIFilter.vibrance()
filter.amount = 0.9
filter.inputImage = image
filter.outputImage

// 3: Filter chains
let filter2 = CIFilter.gloom()
filter2.radius = 10
filter2.intensity = 0.7
filter2.inputImage = filter.outputImage

let filter3 = CIFilter.vignette()
filter3.radius = 2
filter3.intensity = 0.9
filter3.inputImage = filter2.outputImage

let finishedImage = filter3.outputImage?.cropped(to: image!.extent)

