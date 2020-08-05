import CoreImage
import CoreImage.CIFilterBuiltins

let url = Bundle.main.url(forResource: "IMG_5276", withExtension: "HEIC")!
var options = [CIImageOption.applyOrientationProperty: true]
let image = CIImage(contentsOf: url, options: options)

// 2: Masked filter
options[.auxiliaryPortraitEffectsMatte] = true
let matte = CIImage(contentsOf: url, options: options)

let scaleX = matte!.extent.width / image!.extent.width
let scaleY = matte!.extent.height / image!.extent.height

let resizedImage = image?.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))

let invertedFilter = CIFilter.colorInvert()
invertedFilter.inputImage = matte
invertedFilter.outputImage

let maskedFilter = CIFilter.maskedVariableBlur()
maskedFilter.inputImage = resizedImage
maskedFilter.mask = invertedFilter.outputImage
maskedFilter.radius = 20
maskedFilter.outputImage

// 3: Manually background filtering
//let vibrancyFilter = CIFilter.vibrance()
//vibrancyFilter.inputImage = resizedImage
//vibrancyFilter.amount = 0.8
//
//let bgDiscBlur = CIFilter.discBlur()
//bgDiscBlur.inputImage = vibrancyFilter.outputImage
//bgDiscBlur.radius = 8
//
//let bgVignette = CIFilter.vignette()
//bgVignette.inputImage = bgDiscBlur.outputImage?.cropped(to: resizedImage!.extent)
//bgVignette.intensity = 0.8
//bgVignette.radius = 20
//bgVignette.outputImage

// 4: Composting images
let background = resizedImage?
    .applyingFilter("CIVibrance", parameters: ["inputAmount" : -0.8])
    .applyingFilter("CIDiscBlur", parameters: ["inputRadius" : 20])
    .cropped(to: resizedImage!.extent)
    .applyingFilter("CIVignette", parameters: ["inputIntensity" : 0.7, "inputRadius" : 20])

let foregroundVibrancyFilter = CIFilter.vibrance()
foregroundVibrancyFilter.inputImage = resizedImage
foregroundVibrancyFilter.amount = 0.7
let foreground = foregroundVibrancyFilter.outputImage

let blendWithMaskFilter = CIFilter.blendWithMask()
blendWithMaskFilter.backgroundImage = background
blendWithMaskFilter.maskImage = matte
blendWithMaskFilter.inputImage = foreground
blendWithMaskFilter.outputImage

// 5: Artistic images
let sunbeamsFilter = CIFilter.sunbeamsGenerator()
sunbeamsFilter.color = .red
sunbeamsFilter.sunRadius = 50
sunbeamsFilter.striationStrength = 0.6
let sun = sunbeamsFilter.outputImage?.transformed(by: CGAffineTransform.init(translationX: 0, y: 500))

let sunCompositingFilter = CIFilter.lightenBlendMode()
sunCompositingFilter.inputImage = resizedImage
sunCompositingFilter.backgroundImage = sun

sunCompositingFilter.outputImage

