// UIImage+AnimatedGIF.swift
import UIKit
import ImageIO

extension UIImage {
    
    public static func animatedImage(withAnimatedGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return animatedImageWithAnimatedGIFDataSource(source, data: data)
    }
    
    public static func animatedImage(withAnimatedGIFURL url: URL) -> UIImage? {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        return animatedImageWithAnimatedGIFReleasingImageSource(source)
    }
    
    // MARK: - Private Helpers
    
    private static func delayCentiseconds(forImageAtIndex index: Int, source: CGImageSource) -> Int {
        var delayCentiseconds = 1
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any] else {
            return delayCentiseconds
        }
        
        var number = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? Double
        if number == nil || number == 0 {
            number = gifProperties[kCGImagePropertyGIFDelayTime] as? Double
        }
        if let delay = number, delay > 0 {
            delayCentiseconds = Int(lrint(delay * 100))
        }
        return delayCentiseconds
    }
    
    private static func createImagesAndDelays(source: CGImageSource, count: Int) -> ([CGImage], [Int]) {
        var images: [CGImage] = []
        var delays: [Int] = []
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            delays.append(delayCentiseconds(forImageAtIndex: i, source: source))
        }
        return (images, delays)
    }
    
    private static func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a, b = b
        if a < b { swap(&a, &b) }
        while true {
            let r = a % b
            if r == 0 { return b }
            a = b
            b = r
        }
    }
    
    private static func vectorGCD(values: [Int]) -> Int {
        values.reduce(values[0]) { gcd($0, $1) }
    }
    
    private static func frameArray(images: [CGImage], delayCentiseconds: [Int], totalDurationCentiseconds: Int) -> [UIImage] {
        let gcd = vectorGCD(values: delayCentiseconds)
        var frames: [UIImage] = []
        for (i, cgImage) in images.enumerated() {
            let frame = UIImage(cgImage: cgImage)
            let repeatCount = delayCentiseconds[i] / gcd
            frames.append(contentsOf: Array(repeating: frame, count: repeatCount))
        }
        return frames
    }
    
    private static func animatedImageWithAnimatedGIFImageSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        let (images, delays) = createImagesAndDelays(source: source, count: count)
        let totalDuration = delays.reduce(0, +)
        let frames = frameArray(images: images, delayCentiseconds: delays, totalDurationCentiseconds: totalDuration)
        return UIImage.animatedImage(with: frames, duration: TimeInterval(totalDuration) / 100.0)
    }
    
    private static func animatedImageWithAnimatedGIFDataSource(_ source: CGImageSource, data: Data) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        if count <= 1 {
            return UIImage(data: data)  // no cast needed, already Data
        }
        return animatedImageWithAnimatedGIFImageSource(source)
    }
    
    private static func animatedImageWithAnimatedGIFReleasingImageSource(_ source: CGImageSource) -> UIImage? {
        return animatedImageWithAnimatedGIFImageSource(source)
    }
}
