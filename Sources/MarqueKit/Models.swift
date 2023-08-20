//
//  Models.swift
//  
//
//  Created by PEXAVC on 8/20/23.
//

import Foundation

extension MarqueKit {
    public struct EncodeResult {
        public let data: MarqueImage
    }
    
    public struct EncodeDataResult {
        public let data: Data
    }
    
    public struct EncodeBytesResult {
        public let data: [UInt32]
    }
    
    public struct EncodeAudioResult {
        public let data: [UInt32]
    }
    
    public struct DecodeResult {
        public let payload: String
        public let parts: [String]
    }
}
