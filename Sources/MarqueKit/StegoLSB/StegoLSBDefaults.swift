import Foundation

public struct StegoLSBDefaults {
    static let initalShift = 7
    static let bytesPerPixel = 4
    static let bitsPerComponent = 8
    static let bytesOfLength = 4
    
    static var sizeOfInfoLength: Int {
        return bytesOfLength * bitsPerComponent
    }
    
    public static var dataPrefix = "<m12>"
    public static var dataSuffix = "</m12>"
    
    static var minPixelsToMessage: Int {
        return (dataPrefix.count + dataSuffix.count) * bitsPerComponent
    }
    
    static var minPixels: Int {
        return sizeOfInfoLength + minPixelsToMessage
    }
}
