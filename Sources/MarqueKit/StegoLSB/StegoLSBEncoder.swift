import Foundation

class StegoLSBEncoder {
    func encode(string: String,
                in pixelsToMutate: [UInt32], size: Int) throws  -> [UInt32]{
        
        var pixels = pixelsToMutate
        
        guard let message = messageToHide(string: string) else { throw StegoLSBError.unableToEncodeData }
        
        var length = message.count
        
        if (length * StegoLSBDefaults.bitsPerComponent) < (size - StegoLSBDefaults.sizeOfInfoLength) {
            reset()
            
            let data = NSData(bytes: &length, length: StegoLSBDefaults.bytesOfLength)
            
            let lengthDataInfo = String.init(data: data as Data, encoding: .ascii) ?? ""
            
            var pixelPosition: Int = 0
            
            self.dataToHide = lengthDataInfo
            
            while pixelPosition < StegoLSBDefaults.sizeOfInfoLength {
                pixels[pixelPosition] = self.newPixel(pixel: pixels[pixelPosition])
                pixelPosition += 1
            }
            
            reset()
            
            let pixelsToHide = message.count * StegoLSBDefaults.bitsPerComponent
            
            self.dataToHide = message
            
            let ratio = (size - pixelPosition) / pixelsToHide
            
            let salt = ratio
            
            while pixelPosition <= size {
                pixels[pixelPosition] = self.newPixel(pixel: pixels[pixelPosition])
                pixelPosition += salt
            }
        }
        
        return pixels
    }
    
    private func newPixel(pixel: UInt32) -> UInt32 {
        let color = self.newColor(color: pixel)
        self.step += 1
        return color
    }
    
    private func newColor(color: UInt32) -> UInt32 {
        if self.dataToHide.count > self.currentCharacter {
            let asciiCode = UInt32((self.dataToHide as NSString).character(at: self.currentCharacter))
            let shiftedBits = asciiCode >> self.currentShift
            
            if currentShift == 0 {
                currentShift = StegoLSBDefaults.initalShift
                currentCharacter += 1
            } else {
                currentShift -= 1
            }
            
            return StegoLSBUtilities.newPixel(pixel: color,
                                              shiftedBits: shiftedBits,
                                              shift: StegoLSBUtilities.colorToStep(step: self.step).rawValue)
        }
        
        return color
    }
    
    private func reset() {
        self.currentShift = StegoLSBDefaults.initalShift
        self.currentCharacter = 0
    }
    
    private func messageToHide(string: String) -> String? {
        let data = string.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else { return nil }
        
        return StegoLSBDefaults.dataPrefix + base64String + StegoLSBDefaults.dataSuffix
    }
    
    private var currentShift: Int = StegoLSBDefaults.initalShift
    private var currentCharacter: Int = 0
    private var step: UInt32 = 0
    private var dataToHide: String = ""
}
