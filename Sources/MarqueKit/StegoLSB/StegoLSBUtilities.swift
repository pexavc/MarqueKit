import Foundation

struct StegoLSBUtilities {
    static func mask8(_ x: UInt32) -> UInt32{
        return x & 0xFF
    }
    
    static func color(_ x: UInt32, shift: Int) -> UInt32 {
        return mask8(x >> (8 * UInt32(shift)))
    }
    
    static func addBits(number1: UInt32, number2: UInt32, shift: Int) -> UInt32 {
        return (number1 | mask8(number2) << (8 * UInt32(shift)))
    }
    
    static func newPixel(pixel: UInt32, shiftedBits: UInt32, shift: Int) -> UInt32 {
        let bit = (shiftedBits & 1) << (8 * UInt32(shift))
        let colorAndNot = (pixel & ~(1 << (8 * UInt32(shift))))
        return colorAndNot | bit
    }
    
    static func colorToStep(step: UInt32) -> PixelColor {
        if step % 3 == 0 {
            return .blue;
        } else if step % 2 == 0 {
            return .green;
        } else {
            return .red;
        }
    }
}

enum PixelColor: Int {
    case red = 0
    case green = 1
    case blue = 2
}
