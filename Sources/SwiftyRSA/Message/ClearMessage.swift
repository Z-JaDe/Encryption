//
//  ClearMessage.swift
//  SwiftyRSA
//
//  Created by Lois Di Qual on 5/18/17.
//  Copyright © 2017 Scoop. All rights reserved.
//

import Foundation
import FunctionalSwift
public struct ClearMessage: NormalDataWrapper {
    public let data: Data
    public init(data: Data) {
        self.data = data
    }
}
extension ClearMessage {
    ///根据公钥 加密数据
    public func encrypted(with key: PublicKey, padding: Padding) throws -> EncryptedMessage {
        let blockSize = key.blockSize

        var maxChunkSize: Int
        switch padding {
        case []:
            maxChunkSize = blockSize
        case .OAEP:
            maxChunkSize = blockSize - 42
        default:
            maxChunkSize = blockSize - 11
        }
        let encryptedDataBytes: [UInt8] = try data.bytes.chunk(UInt(maxChunkSize)).reduce(into: []) { (result, chunkData) in
            var encryptedDataLength = Int(blockSize)
            var encryptedDataBuffer = [UInt8](repeating: 0, count: encryptedDataLength)
            let chunkData = Array(chunkData)
            let status = SecKeyEncrypt(key.reference, padding, chunkData, chunkData.count, &encryptedDataBuffer, &encryptedDataLength)
            guard status == noErr else {
                throw SwiftyRSAError.chunkEncryptFailed(index: result.count)
            }
            result.append(contentsOf: encryptedDataBuffer)
        }
        return EncryptedMessage(data: Data(encryptedDataBytes))
//        
//        var decryptedDataAsArray = [UInt8](repeating: 0, count: data.count)
//        (data as NSData).getBytes(&decryptedDataAsArray, length: data.count)
//        
//        var encryptedDataBytes = [UInt8](repeating: 0, count: 0)
//        var idx = 0
//        while idx < decryptedDataAsArray.count {
//            
//            let idxEnd = min(idx + maxChunkSize, decryptedDataAsArray.count)
//            let chunkData = [UInt8](decryptedDataAsArray[idx..<idxEnd])
//            
//            var encryptedDataBuffer = [UInt8](repeating: 0, count: blockSize)
//            var encryptedDataLength = blockSize
//            
//            let status = SecKeyEncrypt(key.reference, padding, chunkData, chunkData.count, &encryptedDataBuffer, &encryptedDataLength)
//            
//            guard status == noErr else {
//                throw SwiftyRSAError.chunkEncryptFailed(index: idx)
//            }
//            
//            encryptedDataBytes += encryptedDataBuffer
//            
//            idx += maxChunkSize
//        }
//        
//        let encryptedData = Data(bytes: UnsafePointer<UInt8>(encryptedDataBytes), count: encryptedDataBytes.count)
//        return EncryptedMessage(data: encryptedData)
    }

}
