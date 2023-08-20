#if os(iOS)
import UIKit
public typealias MarqueImage = UIImage
#elseif os(macOS)
import AppKit
public typealias MarqueImage = NSImage

extension NSBitmapImageRep {
    public var png: Data? { representation(using: .png, properties: [:]) }
    public var jpeg: Data? { representation(using: .jpeg, properties: [:]) }
}
extension Data {
    public var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}
extension NSImage {
    public var png: Data? { tiffRepresentation?.bitmap?.png }
    public var jpeg: Data? { tiffRepresentation?.bitmap?.jpeg }
}
#endif


public class MarqueKit {
    public static var shared: MarqueKit = .init()
    
    //token, customizable, dictionary usage (i.e. storing JSON data)
    public static var symbol: String = "*Pa+12"
    
    private var encoder = StegoLSBEncoder()
    private var decoder = StegoLSBDecoder()
    
    public init() {}
    
    private func reset() {
        encoder = .init()
        decoder = .init()
    }
    
    /*
     WIP
     */
    //    public func encodeAudio(_ message: String,
    //                            withSamples samples: [UInt32],
    //                            completion: @escaping ((EncodeAudioResult) -> Void)) {
    //
    //        guard let bytes = try? encoder.hide(string: message, in: samples, size: samples.count) else {
    //            completion(.init(data: []))
    //            return
    //        }
    //
    //        completion(.init(data: bytes))
    ////
    ////        let data = Data.init(bytes: bytes, count: bytes.count)
    ////
    ////        guard let image = MarqueImage.init(data: data) else {
    ////            completion(.init(data: .init()))
    ////            return
    ////        }
    ////
    ////        completion(.init(data: image))
    //    }
    
    /*
     WIP
     */
    public static func writeAssetURL(image : MarqueImage, jpg : Bool = false) -> URL? {
#if os(macOS)
        return nil
#else
        do {
            let exportPath: NSString = NSTemporaryDirectory().appendingFormat("la_marque_image_\(0)\((jpg ? ".jpg" : ".png"))" as NSString)
            
            let assetURL = URL(fileURLWithPath: exportPath as String)
            
            try image.pngData()?.write(to: assetURL)
            
            return assetURL
        } catch {
            return nil
        }
#endif
    }
}

extension Data {
    func toArray<T>(type: T.Type) -> [T] where T: ExpressibleByIntegerLiteral {
        Array(unsafeUninitializedCapacity: self.count/MemoryLayout<T>.stride) { (buffer, i) in
            i = copyBytes(to: buffer) / MemoryLayout<T>.stride
        }
    }
}

//MARK: Decode LSB

extension MarqueKit {
    public func decode(image: MarqueImage) -> DecodeResult {
        guard let objectData = image.pngData() else {
            return .init(payload: "", parts: [])
        }
        
        return decodeData(objectData)
    }
    
    public func decodeData(_ object: Data) -> DecodeResult {
        let array = object.toArray(type: UInt32.self)
        
        return decodeBytes(array)
    }
    
    //Base encoding type is [UInt32], can be used to send web based buffer
    public func decodeBytes(_ bytes: [UInt32]) -> DecodeResult {
        guard let message = try? decoder.decode(in: bytes, size: bytes.count) else {
            return .init(payload: "", parts: [])
        }
        reset()
        return .init(payload: message,
                     parts: message.components(separatedBy: MarqueKit.symbol))
    }
}

//MARK: Encode LSB
//TODO: JSON dictionary messages
extension MarqueKit {
    public func encode(_ message: String,
                       withImage object: MarqueImage) -> EncodeResult {
        guard let objectData = object.pngData() else {
            return .init(data: .init())
        }
        
        let result = encodeData(message, withData: objectData)
        
        guard let image = MarqueImage.init(data: result.data) else {
            return .init(data: .init())
        }
        return .init(data: image)
    }
    
    public func encodeData(_ message: String,
                           withData object: Data) -> EncodeDataResult {
        let result = encodeBytes(message, withArray: object.toArray(type: UInt32.self))
        
        let data = Data.init(bytes: result.data, count: result.data.count)
        
        return .init(data: data)
    }
    
    public func encodeBytes(_ message: String,
                            withArray object: Array<UInt32>) -> EncodeBytesResult {
        guard let bytes = try? encoder.encode(string: message, in: object, size: object.count) else {
            return .init(data: .init())
        }
        reset()
        return .init(data: bytes)
    }
}
