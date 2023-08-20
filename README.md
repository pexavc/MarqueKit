# MarqueKit

MarqueKit is a series of tools for creative encryption methods. Hiding data within various media types. Opening methods of sharing other than standards like QR Codes.

## Stego (Least Significant Bit)

```swift
//Same image with encoded data
MarqueKit.shared.encode("Hello", withImage: ...) -> EncodeResult

public struct EncodeResult {
    public let data: MarqueImage
}
    
//Returns "Hello" from encoded Image
MarqueKit.shared.decode(image: ...) -> DecodeResult

public struct DecodeResult {
    public let payload: String
    public let parts: [String]
}
```

## Credits

- Stego LSB is based on [ISStego](https://github.com/isena/ISStego) by [@isena](https://github.com/isena)
