//
//  EncryptedMessage.swift
//  SwiftyRSA
//
//  Created by Lois Di Qual on 5/18/17.
//  Copyright © 2017 Scoop. All rights reserved.
//

import Foundation

public struct EncryptedMessage: Base64DataWrapper {
    /// 加密好的数据
    public let data: Data
    public init(data: Data) {
        self.data = data
    }
}
extension EncryptedMessage {
    /// 根据私钥解密
    public func decrypted(with key: PrivateKey, padding: Padding) throws -> ClearMessage {
        let blockSize = key.blockSize

        let decryptedDataBytes: [UInt8] = try data.bytes.chunk(UInt(blockSize)).reduce(into: [], { (result, chunkData) in
            var decryptedDataBuffer = [UInt8](repeating: 0, count: blockSize)
            var decryptedDataLength = blockSize
            let chunkData = Array(chunkData)
            let status = SecKeyDecrypt(key.reference, padding, chunkData, chunkData.count, &decryptedDataBuffer, &decryptedDataLength)
            guard status == noErr else {
                throw SwiftyRSAError.chunkDecryptFailed(index: result.count)
            }
            result.append(contentsOf: decryptedDataBuffer.prefix(decryptedDataLength))
        })
        return ClearMessage(data: Data(decryptedDataBytes))
    }
}
