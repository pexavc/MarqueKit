import MarqueKitObjC

#if os(iOS)
import UIKit
public typealias MarqueImage = UIImage
#elseif os(macOS)
import AppKit
public typealias MarqueImage = NSImage
#endif

public class MarqueKit {
    public static var symbol: String = "*Pa+12"
    
    public struct EncodeResult {
        public let data: MarqueImage
    }
    
    public struct SearchResult {
        public let payload: String
        public let parts: [String]
    }
    
    public init() {}
    
    public func search(_ object: MarqueImage) async -> SearchResult {
        return await withCheckedContinuation({ continuation in
            ISSteganographer.data(fromImage: object) { (data, error) in
                if let data = data,
                   let encryptedMessage = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) {
                    
                    let message = encryptedMessage as String
                    continuation.resume(returning: .init(payload: message, parts: message.components(separatedBy: MarqueKit.symbol)))
                } else {
                    continuation.resume(returning: .init(payload: "", parts: []))
                }
            }
        })
    }
    
    public func encode(_ message: String,
                       withObject object: MarqueImage) async -> EncodeResult {
        return await withCheckedContinuation({ continuation in
            ISSteganographer.hideData(message, withImage: object) { (image, error) in
                if (error != nil) {
                    continuation.resume(returning: EncodeResult(data: .init()))
                } else if let imageCheck = image as? MarqueImage {
                    continuation.resume(returning: EncodeResult(data: imageCheck))
                }
            }
        })
    }
    
    public static func writeAssetURL(image : MarqueImage, jpg : Bool = false) -> URL? {
#if os(macOS)
        return nil
#else
        do {
            
            let exportPath: NSString = NSTemporaryDirectory().appendingFormat("la_marque_image_\(0)\((jpg ? ".jpg" : ".png"))" as NSString)
            
            let assetURL = URL(fileURLWithPath: exportPath as String)
            
            //            if jpg {
            //                try image.jpg!.write(to: assetURL)
            //            } else {
            //                try image.png!.write(to: assetURL)
            //            }
            
            try image.pngData()?.write(to: assetURL)
            
            return assetURL
        } catch {
            return nil
        }
#endif
    }
}
