import Foundation

enum StegoLSBError: Error {
    case unknown
    case imageToSmall
    case invalidImage
    case invalidProvider
    case invalidCFProvider
    case coreGraphicsFailed
    case unableToEncodeData
}
